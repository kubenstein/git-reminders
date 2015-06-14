def mock_git_responses!
  allow(GitReminders::Git).to receive(:tag_commit_hash).and_return('c5092372c501f0a07f0ae0bdbed7a15e18787c0f')
  allow(GitReminders::Git).to receive(:tag_message).and_return('test reminder')
  allow(GitReminders::Git).to receive(:branches_that_contains).and_return(['master', 'branch2'])
  allow(GitReminders::Git).to receive(:head_commit).and_return('deadbeef Fix very nasy bug')
  allow(GitReminders::Git).to receive(:current_branch).and_return('master')
end
