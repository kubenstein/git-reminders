GitReminders (POC) [![Build Status](https://travis-ci.org/kubenstein/git-reminders.png?branch=master)](https://travis-ci.org/kubenstein/git-reminders)
=============

Store temporary reminders in your git repo. Main goal is to provide some mechanism to store and then easily find all deployment instructions that need to be run.

Workflow
---------

Whenever you commit something that will need extra care during or after deployment, such as some rake task or other custom code, just make special tag.
GitReminders will find and display all reminders that need to be run. Only reminders from merged branches will be presented.

Instalation
---------
I will push the gem to rubygems soon, but for now you can install it using [specific_install](https://github.com/rdp/specific_install):

```
gem install specific_install
gem specific_install -l https://github.com/kubenstein/git-reminders.git 
```

Usage
---------
To create reminder under current commit:

```
  git reminder add regenerate_thumbnails
  # your fav text editor opens, so you can type your instructions
```

To list all valid reminders for current commit use `list` command. This is default command.

```
  git reminder
  git reminder list
```

To display reminders use `walk` command. By default reminders will be presented one by one.
If you want to skip waiting after each reminder, so display all at once use `--no-prompt` flag.
If you want to be able to choose to archive particular reminder use `--archive-prompt` flag.
You can also archive reminder automatically by using `--auto-archive` flag.


```
  git reminder walk
  git reminder walk --no-prompt --auto-archive
  git reminder walk --archive-prompt --auto-archive
```

To push reminders to remote repo use `push` command. This command will push all newly created reminders as well as marked as archived to remote server.

```
  git reminder push origin
```

To remove all local reminders that are not on remote server use `sync` command. This command is DESTRUCTIVE since all your not yet pushed reminders, both added and already marked as archived, will be removed.

```
  git reminder sync origin
```

Internals
---------
Git Reminders are just annotated tags. Gem knows which tags are reminders based on tag name. In repo reminders look like:

```
valid reminder:
rmndr_recreate_thumbnails__c2015-06-12_22-54

archived reminder:
DONE_rmndr_recreate_thumbnails__c2015-06-12_22-54__a2015-06-12_22-59
```


TODO
---------
- [ ] change all bare git commands to some ruby git lib calls
- [ ] push to rubygems
- [ ] add tests and all those non-hackathon stuff