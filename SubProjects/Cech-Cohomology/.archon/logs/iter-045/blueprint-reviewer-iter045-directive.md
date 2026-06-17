# Blueprint-reviewer directive — iter-045 (HARD GATE re-confirm, fast path)

Run your usual whole-blueprint audit. The plan agent needs a fresh verdict THIS iter on ONE chapter that
was just rewritten, to gate a prover lane.

## Gate-critical chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (covers `QcohTildeSections.lean`).

The active prover target this iter is `lem:tile_section_localization` (Lean
`AlgebraicGeometry.tile_section_localization`). iter-044's lean-vs-blueprint check (`qts`) flagged 5 major
gaps that have just been addressed by a blueprint-writer (`tsl-step4`) + blueprint-clean pass. Please
confirm whether they are now resolved:

1. **Coverage debt cleared?** Five new blocks were authored for the iter-044 Lean decls
   (`lem:appTop_appIso_inv_eq_res`, `lem:key_morph`, `lem:tile_appIso_comp`,
   `lem:tile_section_ring_identity`, `lem:tile_scalar_compat`) with `\lean{}` pins and `\uses{}`. Are they
   complete + correct (statement matches the Lean signature in `QcohTildeSections.lean`, sketch present)?

2. **`lem:tile_section_comparison` proof corrected?** It should now distinguish underlying-type carrier
   equality (holds) from bundled-module definitional equality (does NOT hold), name the route-(A) helper
   chain, and remain UNPINNED (no `\lean{}`). Verify it no longer over-claims "definitional".

3. **`lem:tile_section_localization` Step 4 fixed?** It must NOT reference `lem:tile_section_comparison` as
   an available Lean declaration; it should describe the underlying-type descent path (`Module R` +
   `IsScalarTower R R_g` threading via `lem:tile_scalar_compat`, `eqToHom` opens transport, base-ring
   descent), AND explicitly acknowledge the V=D(f̄) scalar-compat sub-need (beyond V=⊤) with a stated way to
   obtain it. Its `\uses{}` should point at the real Lean ingredients (`lem:tile_scalar_compat` + the two
   smul bridges), not the unformalized `lem:tile_section_comparison`.

## What I need from you
Per-chapter checklist as usual. For the gate-critical chapter specifically, state clearly:
`complete: true|false`, `correct: true|false`, and whether any must-fix-this-iter finding touches it. If it
is complete + correct with no must-fix, the gate clears and I dispatch the prover on
`tile_section_localization` this iter. If not, name the residual must-fix items.
