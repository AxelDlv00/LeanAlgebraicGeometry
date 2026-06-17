# Session 65 (iter-065) — review summary

## Metadata
- **Project real sorry: 12 → 9** (net −3). First closing iter after a four-iter plateau and the
  iter-064 decomposition. No forced/papered proofs (lean-auditor: 0 axiom-laundering, 0 thin-cat traps).
- **Build: GREEN** — re-verified first-hand: `lake build` of both modules EXIT 0 (8322 / 8330 jobs);
  `lake env lean` clean on both files modulo honest sorry warnings.
- **Lanes: 2 (CSI + OpenImm), both PARTIAL-with-closures.** CSI 4→2; OpenImm 5→4 but the headline
  target is fully closed (see below).
- Headline closures **independently kernel-checked axiom-clean** (`{propext, Classical.choice,
  Quot.sound}`, no `sorryAx`): `higherDirectImage_openImmersion_acyclic`, `pushPull_eval_prod_iso`.

## Headline — Need#1 (open-immersion acyclicity) is CLOSED axiom-clean
`AlgebraicGeometry.higherDirectImage_openImmersion_acyclic` (`R^q j_* = 0` for `j` an affine open
immersion) is now **fully sorry-free**. This was the project's sole stated open-immersion residual
(memory: "Need#2 CLOSED ... sole residual = Need#1: the `_acyclic` leaf"). The entire open-immersion
acyclicity route is done.

**How it closed — the keystone φ'' was DEFINITIONAL, not a 40–80 LOC iso.** The prover spent the
first half of the OpenImm lane trying to build the anticipated 2-part codomain bridge for `sliceReverseRingMap`
(φ''): `mapIso` of `sheafPushforwardContinuousComp'` composed with an object-relabel iso along
`unitIso.inv`. This route kept hitting `(Over.map (unitIso.inv.app Ui)).IsContinuous` and
`(Over.forget ((𝟭 _).obj Ui)).IsContinuous` synthesis failures (the defeq-not-syntactic forms `(𝟭 _).obj Uᵢ`
/ `(functor ⋙ inverse).obj Uᵢ`). The unblock was recognizing the bridge is the **identity by defeq**:
both `Functor.sheafPushforwardContinuousComp` and `Over.mapForget` are `rfl`, so
```
sliceReverseRingMap := sliceStructureSheafHom φ.symm (φ.inv ⁻¹ᵁ Ui)
```
is a single defeq retyping — no bridge morphism at all. With φ'' concrete, the cascade fell:
- `pushforwardSliceAdjunctionH1`/`H2`: the unit/counit naturality squares collapse to proof-irrelevance
  over thin opens-morphisms — `φ.inv.c ≫ φ.hom.c` reduces via `Scheme.Hom.congr_app φ.hom_inv_id`
  (resp. `φ.inv_hom_id`) to a structure-sheaf restriction along the open identity, closed with
  `congr 1` / `Subsingleton.elim` + `CommRingCat.forgetToRingCat_map_hom` + `erw key2; rfl`.
- `pushforwardSlicePullbackIso`: `leftAdjointUniq(…) ≪≫ Iso.refl _` — Step 2 is rfl-clean.
- `pushforward_iso_preserves_qcoh` → `case hqc` → `higherDirectImage_openImmersion_acyclic`: all
  sorry-free.

**Remaining OpenImm sorries (4) are all in the STRETCH goal `higherDirectImage_openImmersion_comp`**
(the `j ≫ f` composite, `R^k f_* (j_* H) ≅ R^k (j∘f)_* H`), which the prover decomposed from 1 bare
sorry into 4 named honest gaps: `hacyc` (f_*-acyclicity of `j_* Iⁿ` — a genuinely NEW vanishing result,
NOT an instance of `_acyclic`), `eRes` (augmentation pushforward), `hexact` (= j_*-acyclicity, reuses
`_acyclic`), `transport` (`pushforwardComp`). Raw count went 5→4 because 4 cascade sorries closed and
the 1 `_comp` sorry expanded to 4.

## CSI — Stubs 2 & 4 cascaded to axiom-clean; only Stubs 5 & 6 remain
The two assigned induction leaves of `pushPull_coprod_prod` closed:
- **`pushPull_coprod_prod_empty`** (empty base) via a new helper `isZero_modules_of_isEmpty`: a sheaf
  of modules over an empty/initial scheme is the zero object (reflect `𝟙 = 0` through faithful
  `toPresheaf`; sections subsingleton via `Module.subsingleton ↑Γ(Z,U)` — must be routed as
  `Subsingleton Γ(M,U)` first then `exact h`, and the coproduct-over-`PEmpty` base is the initial
  scheme via `isColimitEquivIsInitialOfIsEmpty` + `isInitial_iff_isEmpty`).
- **`coprodToProd_isIso_of_equiv`** (reindex along `e : α ≃ β`): source via `Sigma.whiskerEquiv e (Iso.refl)`,
  target via `Pi.whiskerEquiv`, projection-by-projection match. Traps: `Sigma.whiskerEquiv` needs
  explicit `(f:=)(g:=)` (metavar codomain); `rw [Sigma.ι_comp_map']` fails on motive grounds →
  `simp [Sigma.ι_comp_map']`; the product leg needs `erw [Pi.lift_π]` (syntactic-key vs defeq).

With all three `coprodToProd_isIso_*` steps closed, `pushPull_coprod_prod`, Stub 2 `pushPull_sigma_iso`,
and Stub 4 `pushPull_eval_prod_iso` are all axiom-clean (the latter two assembled with no new proof,
only a `synthInstance.maxHeartbeats 800000` bump). Remaining CSI: Stub 5 `cechSection_complex_iso`
(line 1418) and Stub 6 `cechSection_contractible` (line 1477) — both load-bearing for
`CechAugmentedResolution.hSec`, both not attempted this iter, both now frontier-ready.

## Soundness — confirmed three ways, no papering
- **First-hand:** both modules `lake build` EXIT 0; `#print axioms higherDirectImage_openImmersion_acyclic`
  = `{propext, Classical.choice, Quot.sound}` (kernel-checked — confirms the whole acyclic cone,
  including the `congr 1`/`Subsingleton.elim` steps in H1/H2, is sorry-free AND kernel-accepted).
- **lean-auditor (iter065):** 0 axiom-laundering, 0 thin-cat kernel traps, 0 suspect defs; all closed
  decls GENUINE. The `Subsingleton.elim`/`congr 1` closings are over genuinely thin (preorder)
  opens-morphisms — the kernel-soundness trap did NOT fire (and my first-hand axiom check confirms
  the kernel accepted them). 6 must-fix = the 6 honest open sorries; 2 major (stale CSI module
  docstring; duplicated `isZero_of_faithful_preservesZeroMorphisms`); 3 minor.
  Report: `.archon/logs/iter-065/lean-auditor-iter065-report.md`.
- **lean-vs-blueprint-checker** (CSI + OpenImm): both confirm the Lean is mathematically correct and
  the proofs faithfully follow (or definitionally simplify) their blueprint sketches. The
  `pushPull_coprod_prod_empty` route (`IsEmpty ↥Z` vs blueprint's "only open of ⊥") is a sound
  equivalent, not a divergence. ALL must-fix items are blueprint-side (stale NOTEs, over-specified
  φ'' sketch) — addressed/surfaced below.
  Reports: `.archon/logs/iter-065/lean-vs-blueprint-checker-{csi,openimm}-iter065-report.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:pushPull_coprod_prod`: updated stale
  `% NOTE (review iter-064)` → iter-065 CLOSED (both induction leaves + cascade Stubs 2/4 axiom-clean).
- `Cohomology_CechHigherDirectImage.tex`, `lem:pushforward_slice_two_adjunction`: updated stale
  `% NOTE (review iter-064)` (said H1/H2 remain sorry) → iter-065 CLOSED axiom-clean.
- `Cohomology_CechHigherDirectImage.tex`, `lem:pushforward_slice_pullback_iso`: updated stale
  `% NOTE (review iter-064)` (said Step-2 sorry open) → iter-065 CLOSED; acyclicity lemma fully closed.
- No `\leanok` / `\mathlibok` / `\notready` touched. No `\lean{...}` renames needed (all pins verified).

## sync_leanok anomaly (flag for planner — NOT laundering)
`sync_leanok-state.json` reports iter=65 with **added 0 / removed 0 / chapters_touched []**, despite
multiple decls closing this iter. Both lvb checkers independently flag that several sorry-free decls
lack `\leanok` in their blueprint blocks (`pushPull_coprod_prod` + the three `private`
`coprodToProd_isIso_*` / `pushPull_coprod_prod_empty`; and `lem:modules_isoSpec_ext_transport`, closed
back in iter-057). The likely causes: (a) `sync_leanok` cannot resolve `private` declarations under
their unmangled `\lean{...}` names; (b) sync may have run against a tree not reflecting this iter's
uncommitted prover edits (working tree shows only the initial commit on `master`). This is a TOOLING
gap (under-marking of genuinely-closed decls), NOT axiom laundering — I verified the decls are closed
first-hand. I did NOT hand-edit `\leanok` (sync's domain; manual marks would be overwritten). The
planner should force a `sync_leanok` re-run and/or check the private-decl resolution path.

## Coverage debt (dag-query unmatched)
Only 2 `lean_aux` nodes uncovered: `CechAcyclic.affine` (dead, pre-existing) and the new
`isZero_modules_of_isEmpty` (this iter; `[leanok]`). Listed for the planner in recommendations.

## Notes (LOW)
- CSI module docstring (lines 10–34) over-claims steps 5/6 as delivered (both are sorry) — cosmetic.
- `isZero_of_faithful_preservesZeroMorphisms` is duplicated verbatim in OpenImm + CechAugmentedResolution
  (latent joint-import redeclaration risk; flagged since iter-054/063).
- `OpenImmersionPushforward.lean:604–623` RESIDUAL-STATE block embeds an iter number; will go stale.
- blueprint-doctor: no findings.
