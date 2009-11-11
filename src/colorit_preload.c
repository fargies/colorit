

#define _GNU_SOURCE
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <signal.h>
#include <stdlib.h>
#include <dlfcn.h>

#include "colorit.h"

static pid_t child_pid;
static int color_pipe[2];
static int fork_count = 0;

__attribute__ ((constructor)) void colorit_load(void) {
  int new_out;

  if (fork_count++)
    return;

  if (pipe(color_pipe) != 0) {
    perror("pipe creation failed");
    return;
  }

  child_pid = fork();
  if (!child_pid) {
    FILE *fd_in = NULL;
    colorit_data data = { NULL, NULL};

    close(color_pipe[1]);

    if (yylex_init_extra(&data, &data.scaninfo)) {
        perror("init alloc failed");
        exit(1);
    }
    yyset_in(fd_in = fdopen(color_pipe[0], "r"), data.scaninfo);
    data.out = stdout;

    if (colorit_init(&data, LIBCOLORIT_TERM) != 0) {
      fprintf(stderr, "Can't init %s\n", LIBCOLORIT_TERM);
      exit(1);
    }

    yyparse(&data);
    fclose(fd_in);
    exit(0);
  }

  unsetenv("LD_PRELOAD");
  close(color_pipe[0]);
  dup2(color_pipe[1], 1);
  dup2(color_pipe[1], 2);
}

__attribute__ ((destructor)) void colorit_unload(void) {
  if (child_pid && !fork_count) {
    int st;

    close(color_pipe[1]);
    waitpid(child_pid, &st, 0);
    child_pid = -1;
  }
  fork_count--;
}

/*************************************************************
 * Overriden functions
 *************************************************************/
void _exit(int status) {
   void (*__real_exit)(int status) = dlsym(RTLD_NEXT, "_exit");
   colorit_unload();
   __real_exit(status);
   /* Never reached, but silence a compiler warning */
   exit(status);
}

void _Exit(int status) {
   void (*__real_exit)(int status) = dlsym(RTLD_NEXT, "_Exit");
   colorit_unload();
   __real_exit(status);
   /* Never reached, but silence a compiler warning */
   exit(status);
}

