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

To display reminders use `git reminder walk` command. By default reminders will be presented one by one.
If you want to skip waiting after each reminder, so display all at once use `--no-prompt` flag.
If you want to be able to choose to archive reminder  use `--archive-prompt` flag.
You can also archive reminder automatically by using `--auto-archive` flag.


```
  git reminder walk
  git reminder walk --no-prompt --auto-archive
  git reminder walk --archive-prompt --auto-archive
```

To push reminders with remote repo. This command will push all newly created reminders as well as mark as archived on remote server reminders that were archived localy.

```
  git reminder push origin
```

To remove all local reminders that are not in remote use `sync` command. This command is DESTRUCTIVE since all you local, not pushed, both added and already marked as archived reminders will be removed.

```
  git reminder sync origin
```

TODO
---------
- [ ] change all bare git commands to some ruby git lib calls