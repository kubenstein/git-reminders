require 'spec_helper'

describe GitReminders::Repo do

  it 'returns current branch' do
    expect(GitReminders::Git).to receive(:execute).with('git branch').
                                     and_return(GIT_BRANCHES)

    expect(subject.current_branch).to eq 'master'
  end

  it 'returns head commit hash' do
    expect(GitReminders::Git).to receive(:execute).with('git log --oneline -n1').
                                     and_return(GIT_LOG_ONE_LINE)

    expect(subject.head_commit_hash).to eq 'deadbeef'
  end


  it 'sync local tag with remote once, local can be destroyed' do
    expect(GitReminders::Git).to receive(:execute).with('git fetch --prune origin +refs/tags/*:refs/tags/*')

    subject.sync('origin')
  end

  it 'creates a tag' do
    expect(GitReminders::Git).to receive(:execute).with('git log --oneline -n1').
                                     and_return(GIT_LOG_ONE_LINE)
    allow(subject).to receive(:current_time).and_return('TIMESTAMP')

    expect(GitReminders::Tag).to receive(:create).with(
                                     name: 'rmndr_test_tag__cTIMESTAMP',
                                     commit_hash: 'deadbeef',
                                     editor: true
                                 )
    subject.create_tag('test_tag')
  end

  it 'archives tag' do
    tag = instance_double(GitReminders::Tag, name: 'test_tag', commit_hash: 'aaaaaaa', message: 'tag_message')
    allow(subject).to receive(:current_time).and_return('TIMESTAMP')

    expect(GitReminders::Tag).to receive(:create).with(
                                     name: 'DONE_test_tag__aTIMESTAMP',
                                     commit_hash: 'aaaaaaa',
                                     message: 'tag_message'
                                 )
    expect(tag).to receive(:destroy)
    subject.archive_tag(tag)
  end

  xit 'pushes tags to remote server' do
  end

  xit 'returns all runnable merged tags' do
  end

end