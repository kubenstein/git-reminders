def mock_git_responses!
  allow(GitReminders::GitWrapper).to receive(:tag_commit_hash).and_return('c5092372c501f0a07f0ae0bdbed7a15e18787c0f')
  allow(GitReminders::GitWrapper).to receive(:tag_message).and_return('test reminder')
  allow(GitReminders::GitWrapper).to receive(:branches_that_contains).and_return(['master', 'branch2'])
  allow(GitReminders::GitWrapper).to receive(:head_commit_hash).and_return('deadbeef')
  allow(GitReminders::GitWrapper).to receive(:current_branch).and_return('master')
end
