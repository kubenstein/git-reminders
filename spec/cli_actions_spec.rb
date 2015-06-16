require 'spec_helper'

describe GitReminders::CliActions do

  let(:repo) { instance_double(GitReminders::Repo) }
  let(:tag) { instance_double(GitReminders::Tag, name: 'tag_name', message: 'tag_message') }
  let(:tag2) { instance_double(GitReminders::Tag, name: 'tag_name2', message: 'tag_message2') }
  subject { GitReminders::CliActions.new(repo) }

  it 'handles add command' do
    expect(repo).to receive(:create_tag).with('tag_name')
    expect(subject).to receive(:puts).with('Reminder has been created!')
    subject.add('tag_name')
  end

  it 'handles list command' do
    expect(repo).to receive(:all_runnable_merged_tags).and_return([tag, tag2])
    expect(subject).to receive(:puts).with('tag_name').once
    expect(subject).to receive(:puts).with('tag_name2').once
    subject.list
  end

  it 'handles push command' do
    expect(repo).to receive(:push).with('origin')
    subject.push('origin')
  end

  it 'handles push command' do
    expect(repo).to receive(:sync).with('origin')
    subject.sync('origin')
  end

  context 'handles walk command' do
    it 'without any params' do
      expect(repo).to receive(:all_runnable_merged_tags).and_return([tag, tag2])
      expect(subject).to receive(:puts).with("** reminder: tag_name **\n\n").once
      expect(subject).to receive(:puts).with("tag_message\n").once
      expect(subject).to receive(:puts).with("** reminder: tag_name2 **\n\n").once
      expect(subject).to receive(:puts).with("tag_message2\n").once
      expect(STDIN).to receive(:gets).twice
      subject.walk
    end

    it 'with no-prompt param' do
      expect(repo).to receive(:all_runnable_merged_tags).and_return([tag])
      expect(STDIN).not_to receive(:gets)
      subject.walk('no-prompt' => true)
    end

    it 'with auto-archive param' do
      expect(repo).to receive(:all_runnable_merged_tags).and_return([tag])
      expect(repo).to receive(:archive_tag).with(tag)
      allow(STDIN).to receive(:gets)
      subject.walk('auto-archive' => true)
    end

    context 'with archive-prompt params' do
      it 'set to YES' do
        expect(repo).to receive(:all_runnable_merged_tags).and_return([tag])

        expect(STDIN).to receive(:gets).and_return('Y')
        expect(repo).to receive(:archive_tag).with(tag)
        subject.walk('archive-prompt' => true)
      end

      it 'set to NO' do
        expect(repo).to receive(:all_runnable_merged_tags).and_return([tag])

        expect(STDIN).to receive(:gets).and_return('N')
        expect(repo).not_to receive(:archive_tag)
        subject.walk('archive-prompt' => true)
      end
    end
  end

end