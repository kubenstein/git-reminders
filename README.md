GitReminders (POC)
=============

Store temporary reminders in your git repo. Main goal is to provide some mechanism to store and then easily find all deployment instructions that need to be run.

Workflow
---------

Whenever you commit something that will need extra care during or after deployment, such as some rake task or other custom code, just make special tag. Tag's message should contain executable code you want to run.
GitReminders will find all display all reminders that need to be run. Only reminders from merged branches will be presented.

Usage
---------
To create reminder under current commit:

```
  git reminder add regenerate_thumbnails
  # your fav text editor opens, and you can type some instructions
```

To list all valid reminders for current commit use `list` command. This is default command.

```
  git reminder
  git reminder list
```

To display reminders one by one use `git reminder walk` command. if you want to be able to choose to set reminder as done use `--prompt-delete` flag:

```
  git reminder walk
  git reminder walk --prompt-delete
```

To sync reminders with remote repo:

```
  git reminder sync origin
```

TODO
---------
- [ ] implement add command
- [ ] implement walk command
- [ ] implement sync command