require 'spec_helper'

describe GitReminders::Tag do
  subject { GitReminders::Tag.new('test_tag') }

  it 'returns hash of the associated commit' do
    expect(GitReminders::Git).to receive(:execute).with('git cat-file tag test_tag').
                                     and_return(GIT_TAG_OBJECT)

    expect(subject.commit_hash).to eq 'c5092372c501f0a07f0ae0bdbed7a15e18787c0f'
  end

  it 'returns tag message' do
    expect(GitReminders::Git).to receive(:execute).with('git cat-file tag test_tag').
                                     and_return(GIT_TAG_OBJECT)

    expect(subject.message).to eq 'test reminder'
  end

  it 'returns list of branches that contain this tag' do
    expect(GitReminders::Git).to receive(:execute).with('git branch --contains deadbeef').
                                     and_return(GIT_TAG_CONTAINED_IN_BRANCHES)
    expect(subject).to receive(:commit_hash).and_return('deadbeef')

    expect(subject.appeared_in_branches).to eq ['master', 'branch2']
  end

  it 'destroy itself' do
    expect(GitReminders::Git).to receive(:execute).with('git tag -d test_tag')
    subject.destroy
  end

  context 'create factory' do
    it 'creates tag with message given as a parameter' do
      fake_temp_file = double().as_null_object
      expect(Tempfile).to receive(:new).and_return(fake_temp_file)
      expect(fake_temp_file).to receive(:path).and_return('/path/to/tmp')

      expect(fake_temp_file).to receive(:write).with('tag_message')
      expect(GitReminders::Git).to receive(:execute).with('git tag -a -F /path/to/tmp test_tag deadbeef')

      GitReminders::Tag.create(name: 'test_tag', commit_hash: 'deadbeef', message: 'tag_message')
    end

    it 'creates tag with message from your favorite text editor' do
      expect(Kernel).to receive(:system).with('git tag -a test_tag deadbeef')

      GitReminders::Tag.create(name: 'test_tag', commit_hash: 'deadbeef', editor: true)
    end


  end

end