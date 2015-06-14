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

  it 'returns all runnable merged tags' do
    tag1 = instance_double(GitReminders::Tag, name: 'tag_on_master')
    tag2 = instance_double(GitReminders::Tag, name: 'tag_on_master_also')
    tag3 = instance_double(GitReminders::Tag, name: 'tag_NOT_on_master')

    allow(GitReminders::Git).to receive(:current_branch).and_return('master')

    expect(tag1).to receive(:appeared_in_branches).and_return(['master', 'branch1'])
    expect(tag2).to receive(:appeared_in_branches).and_return(['master', 'branch2'])
    expect(tag3).to receive(:appeared_in_branches).and_return(['branch2', 'bugfix'])

    allow(subject).to receive(:all_tags_with_identifier).and_return([tag1, tag2, tag3])
    expect(subject.all_runnable_merged_tags.map(&:name)).to eq ['tag_on_master', 'tag_on_master_also']
  end

end