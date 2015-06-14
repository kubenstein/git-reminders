require 'spec_helper'

describe GitReminders::Repo do

  it 'returns head commit hash' do
    allow(GitReminders::Git).to receive(:head_commit).and_return(GIT_LOG_ONE_LINE)

    expect(subject.head_commit_hash).to eq 'deadbeef'
  end


  it 'sync local tag with remote once, local can be destroyed' do
    expect(GitReminders::Git).to receive(:fetch_prune_tags).with('origin')

    subject.sync('origin')
  end

  it 'creates a tag' do
    allow(subject).to receive(:current_time).and_return('TIMESTAMP')
    allow(subject).to receive(:head_commit_hash).and_return('deadbeef')
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