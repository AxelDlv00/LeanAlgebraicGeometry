Workspace hygiene pass for the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon, focused on what lane pic-g touched this session (run 0096, round 3).

Scope of my writes this session:
- New Lean: MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/P1Curve.lean, .../Curve/P1H1Vanishing.lean
- Edited Lean: .../AlgebraicJacobian.lean (2 imports), .../Picard/Pic0VanishingRoute.lean (docstring), .../Albanese/Genus0VanishingDatum.lean (docstring)
- Roadmap: created and own AJCR.w4-rep.datum.p1-witness (+ its C-0001 comment)
- Inbox: created I-1579 (conversation, archived), I-1582, I-1583, I-1603; commented on I-1222 (C-0030, C-0031), I-1582, I-1595, I-1596, I-1597, I-1598; archived I-1537, I-1564, I-1573, I-1574, I-1575, I-1595, I-1596, I-1598, I-1579
- Task: comment on task pic-g

What I want checked, and please report rather than assume:
1. Is the open inbox working set healthy after my archives? The CLI warned about "9 open info items (max 4)" and "31 open non-protection items (max 30)" earlier. Which of the currently-open info/memory items are genuinely consumed and archivable, and are any of MINE (I-1582, I-1583, I-1603) redundant with each other or with existing items? Do not archive standing protections.
2. Roadmap consistency: the CLI reports 23 active items (recommended max 8) and a parent/child mismatch on AJCR.w4-rep.datum.dat-b ("every sub-item is done"). Are these pre-existing or caused by me? Is my new row correctly parented and non-duplicative of AJCR.w4-rep.datum.vanishing-route (which I also own from last round and left pending)?
3. Is there any duplicate/stale row or item describing the same P1 curve-package work, in either AJCR or the AJC sibling, that should be cross-referenced or retired?
4. Scratch/file hygiene under MainProjects/Algebraic-Jacobian-Challenge-Rebuild: I deleted my own 12 ScratchP1/Pg*.lean probes. Are there other scratch directories from this session (e.g. ScratchWRaudit/ from my reviewer subagent) that should be removed, and are they gitignored? Check with `git check-ignore -v` against the actual files, not by reading .gitignore.
5. Any uncommitted authored change left on disk in my write set (compare disk against HEAD using the ledger git: `git --git-dir /home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/vcs/workspace.git --work-tree /home/axel/LeanAlgebraicGeometry-Horizon ...`).

You may perform safe hygiene actions (archiving genuinely consumed non-protection inbox items, removing scratch files that are clearly session debris and gitignored). Do NOT edit any Lean source, do not change roadmap statuses or owners, and do not touch another lane's files. Report what you did and what you recommend I do.
