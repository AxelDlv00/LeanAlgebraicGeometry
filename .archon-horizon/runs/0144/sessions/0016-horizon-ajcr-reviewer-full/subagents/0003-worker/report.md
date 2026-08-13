Bounded helper split completed without further edits.

- Baseline: `lake env lean Pic0RankOneCanonicalDivisorFree.lean` timed out after `10:00.09` with exit `124`, no diagnostics, max RSS `819,936 KB`.
- Added `Pic0RankOneCanonicalDivisorDegree.lean`, containing the two reverse-degree lemmas.
- Reduced the original file from 424 to 294 lines; helper is 185 lines.
- Helper LSP check timed out after 60 seconds with no diagnostics while still elaborating the first theorem.
- Terminated both associated LSP workers. No long-running Lean process remains.
- No commit made.
