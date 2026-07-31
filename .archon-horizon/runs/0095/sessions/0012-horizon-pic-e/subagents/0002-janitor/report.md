Workspace hygiene pass for the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon. Dispatched by lane pic-e (run 0095, round 5, project MainProjects/Algebraic-Jacobian-Challenge) because the CLI printed collection-health warnings I am required to act on rather than scroll past.

THE WARNINGS I OBSERVED, verbatim in substance:
- "Inbox has 44 open non-protection items (recommended maximum 30)"
- "Roadmap has 23 active items (recommended maximum 8)" — this one has already been analysed by a previous janitor pass as I-1607, which found that most 'active' rows are CONE rows with children rather than competing fronts. Read I-1607 before touching roadmap statuses; do not re-derive its analysis, and do not mark a cone pending if I-1607 argued that is intentional.

WHAT TO DO:
1. Archive or complete inbox items that are genuinely consumed/stale. THE HAZARD, and it is not hypothetical — I did this wrong in an earlier round of this same run: "archive stale info items" selects on kind and age, and in an eight-lane round the NEWEST info item is almost always some lane's LIVE CLAIM. Before archiving any info item, check whether it is a CLAIM whose lane still holds the row at HEAD (`git show HEAD:.archon-horizon/roadmap/items/<id>.yaml`). Items I-1613 (my claim) and my RESULT/RELEASE note from this session are consumed — I-1613 can be archived since I released the row; the RESULT note should stay. Live claims from pic-b/pic-c/pic-g should NOT be archived unless their run has stopped AND the row is released at HEAD. `horizon ps` shows which runs are still alive.
2. Never archive a standing protection to shorten the list (I-1222, I-0838, I-1482, I-0491, I-0074 are binding).
3. There are TWO long-standing infrastructure issues worth checking rather than closing blind: I-1504 / I-1583 (a stale ZERO-BYTE .archon-horizon/vcs/workspace.git/index.lock that HANGS plain `git commit`) and I-1222 (the shared index currently holds ~14400 staged deletions, 114 of them .lean files). Re-measure both and record what you find; do NOT delete the lock without reading the second half of I-1504, which argues the lock is currently the only thing preventing a mass staged-D clobber.

COMMIT DISCIPLINE, mandatory — the shared index is contaminated as described above, so a plain `git add`/`git commit` will destroy other lanes' work:
  export GIT_INDEX_FILE=/tmp/janitor-idx; rm -f "$GIT_INDEX_FILE"
  OLD=$("$HORIZON_GIT" rev-parse HEAD); "$HORIZON_GIT" read-tree HEAD
  "$HORIZON_GIT" add <only your explicit paths>
  verify `"$HORIZON_GIT" diff --cached --name-status HEAD` lists ONLY your paths
  TREE=$("$HORIZON_GIT" write-tree)
  NEW=$(printf '%s' "message" | "$HORIZON_GIT" commit-tree "$TREE" -p "$OLD")
  "$HORIZON_GIT" update-ref refs/heads/main "$NEW" "$OLD"
  then `"$HORIZON_GIT" diff HEAD~1 HEAD --name-status` and READ EVERY PATH — one you did not add means you reverted someone; restore from disk.
Plain `git commit` will HANG on the stale lock. Use commit-tree + update-ref with the OLD sha as shown (that is also the compare-and-swap that catches a racing lane).

Report what you changed, what you deliberately left and why, and any warning that survives your pass. Do not touch any .lean file under MainProjects/.
