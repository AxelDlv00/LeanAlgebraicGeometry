You are searching for existing Lean 4 infrastructure. Workspace root: /home/axel/LeanAlgebraicGeometry-Horizon. Two projects: MainProjects/Algebraic-Jacobian-Challenge (`AlgebraicJacobian`) and MainProjects/Algebraic-Jacobian-Challenge-Rebuild. Mathlib is pinned at v4.31-era. READ ONLY — do not edit any file.

The workspace has a declaration index spanning BOTH projects AND mathlib. Use it, it is much better than grep:
  "$HORIZON_BIN" search "<words or name>" --json
(HORIZON_BIN=/home/axel/.archon-env/bin/horizon). Also use grep for known strings.

FIVE QUESTIONS. Answer each with concrete `file:line` citations or a plain "absent".

(1) CARTIER'S THEOREM. Does mathlib (or either project) have any form of: "a group scheme locally of finite type over a field of characteristic zero is smooth / reduced"? Search for `smooth_of_grpObj`, `GeometricallyReduced`, `IsReduced` + group scheme, `Cartier`, and any `CharZero` hypothesis on a group-scheme smoothness statement. Report the exact statement of `smooth_of_grpObj` (it IS used at AlgebraicJacobian/Picard/Pic0Et.lean:159) and list EVERY producer of `GeometricallyReduced` you can find in mathlib and in either project — i.e. every declaration whose CONCLUSION is `GeometricallyReduced _`.

(2) The AJC project needs `GeometricallyReduced (Scheme.Pic0SchemeEt C).hom` (open `sorry` at AlgebraicJacobian/Picard/Pic0Et.lean around line 175, `Scheme.Pic0Et.geometricallyReduced`). Its twin on the other side is `Scheme.Pic0.geometricallyReduced` in `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`. Is the picSharp twin PROVED or `sorry`? Read it and report its statement and body. If it is proved, report exactly how — that is the most important part of your answer.

(3) `UniversallyClosed`: the AJC project needs `UniversallyClosed (Scheme.Pic0SchemeEt C).hom` (`Scheme.Pic0Et.universallyClosed`, Pic0Et.lean around line 228). Its twin `Scheme.Pic0.universallyClosed` in Pic0AbelianVariety.lean — proved or sorry? Report statement and body. Also: list every declaration in either project whose conclusion is `UniversallyClosed _` (a producer), and any mathlib lemma giving universal closedness of an open/clopen subscheme of a proper scheme, or of the identity component of a group scheme.

(4) Does either project have ANY declaration about `GeometricallyReduced` or `IsReduced` or smoothness for `Pic0SchemeEt` / `PicSchemeEt` (the étale side)? Search on the strings `Pic0SchemeEt`, `PicSchemeEt`, `HasPicSchemeEt`, `picEt` and report every file that mentions them with a one-line summary of what it proves about them.

(5) In the SIBLING project Algebraic-Jacobian-Challenge-Rebuild, is there anything proving smoothness, properness, reducedness or the dimension/tangent-space count for its Pic^0 object? Search for its Pic0 representability engine (`pic0RepresentableByOfCharts` is said to be at Picard/Pic0SigmaSheaf.lean:161) and report what abelian-variety properties, if any, that project proves about its Pic^0 — and the exact carrier/object its statements bind.

Report factually, tersely, with citations. Never guess a declaration exists: if a search finds nothing, say "absent" and name the search you ran.
