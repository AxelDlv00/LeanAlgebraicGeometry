You are doing a careful, mechanical Lean 4 port inside the Archon Horizon workspace. Read the lean-check skill at /home/axel/LeanAlgebraicGeometry-Horizon/.claude/skills/lean-check/SKILL.md first and FOLLOW ITS LSP LOOP (lean_diagnostic_messages / lean_goal before and after each edit; do not drive this with lake build).

PROJECT: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (work from this directory).

THE TASK. Port a stalk-evaluation engine from the chart-typed carrier `DivisorAdaptation` to the widened carrier `AffAdaptation`, into the EXISTING file:
  AlgebraicJacobian/Picard/DivisorFamilyAffStalkEval.lean
That file already exists, is rooted in AlgebraicJacobian.lean, and currently has exactly TWO `sorry`s, at:
  - `AffAdaptation.deg_presentationDivisor`
  - `AffAdaptation.IsCertified.deg_presentationDivisor`
Its first two lemmas (`span_eq_of_unit_mul`, `span_germ_eqn_eq_stalkIdeal`, `isUnit_germ_eqn_of_coeffAt_eq_zero`) are already proved — do not change them.

SOURCES TO PORT FROM (read them fully):
  - AlgebraicJacobian/Picard/DivisorFamilyStalkEval.lean (349 lines) — declarations from line 124 onward: `mem_span_singleton_of_isUnit_or_mem`, `stalkColEval`, `stalkColEval_mk`, `ovlStalkColEval`, `ovlStalkColEval_toOvlLeft`, `ovlStalkColEval_toOvlRight`, `stalkColEval_glued`, `eqn_ne_zero`, `moduleFinite_stalkQuot`, `finrank_stalkQuot_eq_coeffAt_mul`.
  - AlgebraicJacobian/Picard/DivisorFamilyFieldCRT.lean (409 lines) — the engine: `pieceStalkEval` and its injectivity/surjectivity/bijectivity, `gluedStalkEval`, `gluedStalkEval_injective`, `pieceTarget`, `gluedStalkEval_surjective`, and finally `deg_presentationDivisor` (line 324) and `IsCertified.deg_presentationDivisor` (line 365).

THE SUBSTITUTION RULE, and it is the whole point of the port. The chart-typed side indexes pieces through a `Sum` index inside `FinCoverData` and types each piece into one of two pinned P1 charts. The widened side (`AffCoverData`, structure at AlgebraicJacobian/Picard/DivisorFamilyAffCover.lean:145) has `pieces : Fin m -> Opens`, `isAffineOpen` and `cover` as FIELDS. So:
  - `A.pieces j` becomes `D.pieces j`; `A.index` becomes `D.index`; likewise `A.isAffineOpen_pieces` becomes `D.isAffineOpen_pieces`.
  - The chart-typed `exists_mem_pieces` (DivisorFamilyFieldCRT.lean:179-185) proves its goal from `relCover_sup` + `cover0` + `cover1`. DO NOT PORT THAT PROOF. On the widened side use the already-existing `D.exists_mem_pieces` (AlgebraicJacobian/Picard/DivisorFamilyAffCover.lean:166), which is the structure field.
  - Everything else should transcribe with names unchanged. `AffAdaptation` carries `eqn`, `eqn_rel`, `eqn_regular`, `colength`, `ovlColength`, `ovlIdeal`, `toOvlLeft`, `toOvlRight`, `chartProd`, `ovlProd`, `deltaLeft`, `deltaRight`, `gluedSubmodule`, `mem_gluedSubmodule_iff`, `Glued`, and `IsCertified` with the same clause names.

EXPECTED OUTCOME: the two `sorry`s in DivisorFamilyAffStalkEval.lean are replaced by real proofs, and any helper declarations they need are added to that same file above them (in `namespace AffAdaptation`). The file must end with ZERO sorries and ZERO errors.

IMPORTANT CONSTRAINTS:
1. Edit ONLY AlgebraicJacobian/Picard/DivisorFamilyAffStalkEval.lean. Do not touch any other file — other agents are working in this repo concurrently and a stray edit destroys their work. Do NOT run git commands at all.
2. If a source declaration is `private`, you cannot reference it; copy it into our file as `private` with a docstring saying where it came from and that it is private there.
3. Do not weaken any statement to make it go through. If a step genuinely needs a hypothesis the widened carrier lacks, STOP and report exactly which declaration and which step, leaving that one as `sorry` with a comment. An honest partial port is the required outcome in that case — do not invent a side condition, and do not add a hypothesis to `deg_presentationDivisor` (its whole value is that it has NO separation hypothesis).
4. Preserve `omit [...] in` lines where the source has them; the linter will tell you which instances are unused (it reports "automatically included section variable(s) unused").
5. Write docstrings in the house style of the surrounding file: state what the lemma says mathematically, and where a step differs from the chart-typed original, say so.
6. Keep `set_option` lines at the top of the file as they are.

VERIFY AS YOU GO with lean_diagnostic_messages. When you believe it is complete, run `lake build AlgebraicJacobian.Picard.DivisorFamilyAffStalkEval` ONCE in the foreground and report its exit code and the sorry count.

REPORT BACK: the final sorry count, the build exit code, a list of the declarations you added, and — most importantly — any place where the port was NOT verbatim, with the reason. If you left a sorry, say precisely what blocked it.
