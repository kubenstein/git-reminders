require 'spec_helper'

describe GitReminders::Tag do
  before { mock_git_responses! }
  subject { GitReminders::Tag.new('test_tag') }

  it 'returns hash of the associated commit' do
    expect(GitReminders::Git).to receive(:tag_commit_hash)
    expect(subject.commit_hash).to eq 'c5092372c501f0a07f0ae0bdbed7a15e18787c0f'
  end

  it 'returns tag message' do
    expect(GitReminders::Git).to receive(:tag_message).with(subject.name)

    expect(subject.message).to eq 'test reminder'
  end

  it 'returns list of branches that contain this tag' do
    allow(subject).to receive(:commit_hash).and_return('deadbeef')
    expect(GitReminders::Git).to receive(:branches_that_contains).with('deadbeef')

    expect(subject.appeared_in_branches).to eq ['master', 'branch2']
  end

  it 'destroy itself' do
    expect(GitReminders::Git).to receive(:destroy_tag).with('test_tag')
    subject.destroy
  end

  context 'create factory' do
    it 'creates tag with message given as a parameter' do
      expect(GitReminders::Git).to receive(:create_tag_with_message).with('test_tag', 'deadbeef', 'tag_message')
      expect(GitReminders::Tag).to receive(:new).with('test_tag')

      GitReminders::Tag.create(name: 'test_tag', commit_hash: 'deadbeef', message: 'tag_message')
    end

    it 'creates tag with message from your favorite text editor' do
      expect(GitReminders::Git).to receive(:create_tag_with_message_from_editor).with('test_tag', 'deadbeef')

      GitReminders::Tag.create(name: 'test_tag', commit_hash: 'deadbeef', editor: true)
    end


  end

end