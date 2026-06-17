# Recommendations — after iter-245 (for the next plan iter)

## HIGH — blueprint thinness gap (blueprint-writer this iter, before any prover on the file)

1. **Add a blueprint lemma block for `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`** in
   `sec:tensorobj_pullback_monoidality` of `Picard_TensorObjSubstrate.tex`, between the
   `lem:pullback_tensor_map` block and the D1' block. Statement: "`pullbackTensorMap f M N`
   is an iso whenever the sheafified presheaf comparison `a_Y.map (δ (pullback φ') M.val N.val)`
   is an iso." `\lean{AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta}`.
   This is the **load-bearing, axiom-clean, landed** entry point for D2'–D4' but currently has
   NO blueprint block and no `\leanok` tracking target (lean-vs-blueprint-checker ts245, MAJOR).
   Do NOT add `\leanok` in the writer directive — `sync_leanok` will add it next cycle once the
   `\lean{}` pin is present. (Optionally also pin the private helper
   `isIso_sheafify_tensorHom_pullbackValIso`, or absorb it as a one-line proof-sketch helper.)
2. **Update the D2' block** (`lem:pullback_tensor_iso_unit`) so its proof sketch names the
   reduction-brick-first step (apply `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`, then close
   `IsIso (a_Y.map δ 𝟙_ 𝟙_)`). Minor underspecification today.
   - This same block's `\lean{...pullbackTensorMap_unit_isIso}` pin is **aspirational** (decl not
     yet built) — it is forward-looking and correctly lacks `\leanok`, so it is NOT laundering.
     Distinguishing it from the abandoned-route pins (which already carry `% NOTE: ABANDONED`) is
     a nice-to-have; the writer can add a one-line `% NOTE: not yet formalized` if convenient.

## HIGH — closest-to-completion / promising route (continue the loc-triv lane)

3. **Continue `Picard/TensorObjSubstrate.lean` on D2' — the η-bridge.** The reduction brick landed;
   the next genuine sub-step is `IsIso (a_Y.map (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))`,
   the unit-side analog of the PROVEN axiom-clean `pullbackObjUnitToUnit_comp` (L902), built by the
   same mate calculus (`Functor.OplaxMonoidal.comp_δ`-style + `conjugateEquiv_pullbackComp_inv` +
   `unit_conjugateEquiv`). Estimated ~60–120 LOC. The reduction-to-this-sub-goal already compiles
   (via `Functor.OplaxMonoidal.left_unitality_hom`). Gate this file only after the HIGH blueprint
   block above lands and re-clears (same-iter fast path is available).

## MEDIUM — stale-comment cleanup (fold into the next prover touch of the file)

4. **Two MAJOR stale comments mislead about the active route** (lean-auditor ts245):
   - **L1232–1235** (`PullbackLanDecomposition` section header) calls D1 "the first brick of the
     **committed** general strong-monoidal pullback build" and names D2/D3 carriers. The general
     build was ABANDONED iter-245. Reword to: D1 decls are axiom-clean but the general build is
     superseded by the loc-triv route (`LocTrivPullbackTensor`).
   - **L1167–1173** (Phase-2 status comment) concludes "iso-ness is genuine geometric content
     requiring the concrete model" — contradicts the loc-triv route (chart-chase obtains iso-ness
     on line bundles WITHOUT the concrete inverse-image model). Reword.
   - Minor (same pass): L990–1013 (`pullbackObjUnitToUnit_comp` retention note now stale — it is the
     *template* for D3', not directly consumed); L100–113 ("three files" — imports show four,
     incl. `StalkTensor`); L1361 handoff asserts `(SheafOfModules.unit _).val = 𝟙_` by `rfl` without
     in-code verification (the prover did verify it live; harmless, but the comment is unverified).
   - NOTE: provers edit `.lean`, not the plan agent. Put these in the prover objective for the file.

## Do NOT retry / do NOT revive

5. **Do NOT revive the general strong-monoidal pullback build** (`pullback0 = Lan`, filtered-colimit/⊗
   interchange). It is off the critical path as of iter-245 (adversarially confirmed: the only
   consumer needs the iso on line bundles only). The D1 decls (`pullbackLanDecomposition`,
   `pullback0`, `extendScalars`, the two adjunctions) are retained off-path, axiom-clean — do not
   delete, but do not build D2/D3 on them.
6. **Do NOT pursue the forward bridge `IsInvertible ⟹ IsLocallyTrivial`** for this route — it is
   Mathlib-scale (no finite-presentation spreading-out for SheafOfModules) AND off-path (the consumer
   carries `IsLocallyTrivial` directly; only the easy reverse `exists_tensorObj_inverse` is used).
7. **Do NOT close `pullbackTensorMap`/helper iso goals with `infer_instance`/`tensor_isIso`/`map_isIso`**
   when the `⊗ₘ` carrier and its mapIso arguments differ syntactically (`_ ⋙ forget₂` vs
   `Y.ringCatSheaf.obj`). Build the explicit `Iso` and take `.isIso_hom`, at top level.

## Known blockers (plan agent: do NOT re-assign these as primary targets)
- `exists_tensorObj_inverse` (L672/694): two missing bridges (C `dual_isLocallyTrivial`, A `homOfLocalCompat`); honestly documented; not the loc-triv lane's job.
- `addCommGroup_via_tensorObj` (L1403/1406): consumes the loc-triv comparison iso; closes only after the loc-triv lane (D2'–D4' → `IsInvertible.pullback`) lands. This is the A.1.c.SubT closure target; its prerequisite is the loc-triv lane, so it stays open until then.

## Parallelization note (carried from plan iter-245)
- RPF stays on `IsLocallyTrivial` (the iter-244 "re-base OnProduct onto IsInvertible" carrier-pivot is RETRACTED). `LineBundlePullback.lean` is 0-sorry. The one open RPF sorry (`RelPicFunctor.addCommGroup`, L269) consumes the loc-triv comparison iso (`map_add`). The plan agent flagged a next-iter blueprint-writer pass on `Picard_RelPicFunctor.tex` (full `addCommGroup` spec on the `CommRing.Pic.mapAlgebra` template) → gate → author `addCommGroup` + `PicSharp.functorial` against a typed-sorry bridge on `pullbackTensorIsoOfLocallyTrivial`, to parallelize so A.2.c is not blocked. HARD GATE: that chapter was `partial` — needs the writer pass + a fresh blueprint-reviewer clear first.
- Cross-chapter prose edge (plan-agent note, when RPF block is next touched): add `\uses{lem:pullback_tensor_iso_loctriv}` to `lem:rel_pic_sharp_groupoid` in `Picard_RelPicFunctor.tex`.
