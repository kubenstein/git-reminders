require 'spec_helper'

describe GitReminders::GitWrapper do
  subject { GitReminders::GitWrapper }

  it 'returns branches that contains commit' do
    expect(subject).to receive(:execute).with('git branch --contains deadbeef').
                           and_return('
* master
  branch2
')
    expect(subject.branches_that_contains('deadbeef')).to eq ['master', 'branch2']
  end

  it 'fetches tags' do
    expect(subject).to receive(:execute).with('git fetch --tags origin')
    subject.fetch_tags('origin')
  end

  it 'fetches tags with prune option' do
    expect(subject).to receive(:execute).with('git fetch --prune origin +refs/tags/*:refs/tags/*')
    subject.fetch_prune_tags('origin')
  end

  it 'pushes tags' do
    expect(subject).to receive(:execute).with('git push --tags origin')
    subject.push_tags('origin')
  end

  it 'removes remote tag' do
    expect(subject).to receive(:execute).with('git push origin :tag_name')
    subject.remove_remote_tag('origin', 'tag_name')
  end

  it 'removes local tag' do
    expect(subject).to receive(:execute).with('git tag -d tag_name')
    subject.remove_local_tag('tag_name')
  end

  it 'returns head commit hash' do
    expect(subject).to receive(:execute).with('git log --oneline -n1').and_return('deadbeef Fix very nasy bug')
    expect(subject.head_commit_hash).to eq 'deadbeef'
  end

  it 'returns current branch' do
    expect(subject).to receive(:execute).with('git branch').and_return('
  branch1
  branch2
* master
')
    expect(subject.current_branch).to eq 'master'
  end

  it 'returns tags that starts with identifying text' do
    expect(subject).to receive(:execute).with('git tag -l identifier*').and_return("tag1\ntag2")
    expect(subject.tags_with_identifier('identifier')).to eq ['tag1', 'tag2']
  end

  it 'returns tags commit hash' do
    expect(subject).to receive(:execute).with('git cat-file tag tag_name').and_return('
object c5092372c501f0a07f0ae0bdbed7a15e18787c0f
type commit
tag test_tag
tagger Jakub Niewczas <niewczas.jakub@gmail.com> 1434142793 +0200

test reminder
')
    expect(subject.tag_commit_hash('tag_name')).to eq 'c5092372c501f0a07f0ae0bdbed7a15e18787c0f'
  end

  it 'returns tags commit message' do
    expect(subject).to receive(:execute).with('git cat-file tag tag_name').and_return('
object c5092372c501f0a07f0ae0bdbed7a15e18787c0f
type commit
tag test_tag
tagger Jakub Niewczas <niewczas.jakub@gmail.com> 1434142793 +0200

test reminder
')
    expect(subject.tag_message('tag_name')).to eq 'test reminder'
  end

  it 'creates tag with message taken from editor' do
    expect(Kernel).to receive(:system).with('git tag -a tag_name deadbeef')
    subject.create_tag_with_message_from_editor('tag_name', 'deadbeef')
  end

  it 'creates tag' do
    fake_temp_file = double().as_null_object
    expect(Tempfile).to receive(:new).and_return(fake_temp_file)
    expect(fake_temp_file).to receive(:path).and_return('/path/to/tmp')

    expect(fake_temp_file).to receive(:write).with('message')
    expect(subject).to receive(:execute).with('git tag -a -F /path/to/tmp tag_name deadbeef')

    subject.create_tag_with_message('tag_name', 'deadbeef', 'message')
  end

  it 'destroys tag' do
    expect(subject).to receive(:execute).with('git tag -d tag_name')

    subject.destroy_tag('tag_name')
  end


end