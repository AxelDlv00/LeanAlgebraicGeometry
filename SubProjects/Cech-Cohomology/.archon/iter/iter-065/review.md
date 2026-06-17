# iter-065 review

## Overall progress this iter
- **Project real sorry: 12 → 9 (net −3; first closing iter after the iters-061–064 plateau).** Real
  holes: CSI `cechSection_complex_iso` (1418, Stub 5) + `cechSection_contractible` (1477, Stub 6);
  OpenImm STRETCH `_comp` 4 gaps (974 `hacyc` / 979 `eRes` / 982 `hexact` / 985 `transport`);
  CechHigherDirectImage frozen P5b (780); CechAugmentedResolution (229); CechAcyclic dead `affine` (110).
- **Build: GREEN** — re-verified first-hand: `lake build` of both modules EXIT 0 (8322 / 8330 jobs);
  headline decls `#print axioms` kernel-clean (`{propext, Classical.choice, Quot.sound}`, no `sorryAx`).
- **Lanes: 2 (CSI, OpenImm), both PARTIAL-with-closures.** CSI 4→2; OpenImm 5→4 (but the headline
  target fully closed; raw count moved by 4 cascade closures − 1 + 4 stretch-decomposition).
- **dag-query:** gaps = 0; unmatched = 2 (`isZero_modules_of_isEmpty` new + dead `affine`).
  blueprint-doctor: no findings.

## Headline — Need#1 (open-immersion acyclicity) CLOSED axiom-clean; the φ'' wall was a defeq
`higherDirectImage_openImmersion_acyclic` (`R^q j_* = 0`, `j` an affine open immersion) is now fully
sorry-free and kernel-verified. This was the project's sole stated open-immersion residual; the whole
route is done. The four-iter blocker — the φ'' codomain bridge billed as a "~40–80 LOC object-relabel
iso" — **did not exist**: `Functor.sheafPushforwardContinuousComp` and `Over.mapForget` are both `rfl`,
so `sliceReverseRingMap := sliceStructureSheafHom φ.symm (φ.inv⁻¹ᵁ Ui)` is a single defeq retyping. The
prover burned the first half of the lane on the explicit-bridge route (repeated
`(Over.map (unitIso.inv)).IsContinuous` / `(Over.forget ((𝟭 _).obj Uᵢ)).IsContinuous` synthesis
failures over defeq-not-syntactic index forms) before recognizing the bridge was already defeq-closed.
With φ'' concrete, H1/H2 (thin opens-morphism proof-irrelevance), `pushforwardSlicePullbackIso`
(`leftAdjointUniq ≪≫ Iso.refl _`), `pushforward_iso_preserves_qcoh`, `case hqc`, and the whole acyclic
cone cascaded shut.

The remaining 4 OpenImm sorries are all in the STRETCH `higherDirectImage_openImmersion_comp` (the
`j ≫ f` composite), decomposed from 1 bare sorry into 4 honest gaps. The real one is `hacyc`:
`f_*`-acyclicity of `j_* Iⁿ`, a genuinely NEW vanishing result (not an instance of `_acyclic`).

## CSI — Stubs 2 & 4 cascaded axiom-clean
The two assigned induction leaves of `pushPull_coprod_prod` closed: `pushPull_coprod_prod_empty` (empty
base, via the new helper `isZero_modules_of_isEmpty` — module sheaf over an empty/initial scheme is the
zero object) and `coprodToProd_isIso_of_equiv` (reindex along an equivalence via `Sigma`/`Pi.whiskerEquiv`).
With all three `coprodToProd_isIso_*` steps closed, `pushPull_coprod_prod`, Stub 2 `pushPull_sigma_iso`,
and Stub 4 `pushPull_eval_prod_iso` are axiom-clean (the latter two with zero extra proof). Only Stubs 5
& 6 (the augmented section-complex iso + contracting homotopy, feeding `CechAugmentedResolution.hSec`)
remain on CSI — both frontier-ready, blueprint detail rated adequate.

## Soundness — confirmed, no papering
- **First-hand:** `lake build` EXIT 0 both modules; `#print axioms higherDirectImage_openImmersion_acyclic`
  and `pushPull_eval_prod_iso` kernel-clean (the kernel accepted the `congr 1`/`Subsingleton.elim`
  steps in H1/H2 — the thin-cat soundness trap did NOT fire).
- **lean-auditor `iter065`:** 0 axiom-laundering, 0 thin-cat kernel traps, 0 suspect defs; all closed
  decls GENUINE. 6 must-fix = the 6 honest open sorries; 2 major (stale CSI module docstring over-claims
  Stubs 5/6; `isZero_of_faithful_preservesZeroMorphisms` duplicated OpenImm↔CechAugmentedResolution —
  latent, flagged since iter-054); 3 minor.
- **lvb-csi / lvb-openimm:** both confirm the Lean is mathematically correct and the proofs faithfully
  follow (or definitionally simplify) their blueprint sketches. The `pushPull_coprod_prod_empty` route
  (`IsEmpty ↥Z` vs blueprint's "only open of ⊥") is a sound equivalent. ALL must-fix are blueprint-side.

## Markers I changed
- Updated 3 stale `% NOTE (review iter-064)` comments in `Cohomology_CechHigherDirectImage.tex` →
  iter-065 CLOSED: `lem:pushPull_coprod_prod`, `lem:pushforward_slice_two_adjunction`,
  `lem:pushforward_slice_pullback_iso`. (Comment-only; blueprint-doctor still clean.)
- No `\leanok` / `\mathlibok` / `\notready` / `\lean{...}` changes (all pins verified correct).

## Surfaced to planner (recommendations.md / Known Blockers)
1. **CSI Stubs 5 + 6** — top priority, frontier-ready, single-leaf provers paired; close
   `CechAugmentedResolution.hSec` downstream.
2. **OpenImm STRETCH `_comp`** — PLANNER DECISION; if pursued, effort-break + blueprint `hacyc` (NEW
   `f_*`-acyclicity) first. Do NOT bare-dispatch.
3. **Blueprint-writer (HARD GATE)** — rewrite `lem:slice_reverse_ring_map` proof (2-part bridge is
   non-existent / defeq); split `higherDirectImage_openImmersion_acyclic` out of the co-pinned
   `lem:open_immersion_pushforward_comp` so the closed milestone can get `\leanok`.
4. **sync_leanok under-marking** — iter=65 synced added=0/removed=0 despite closures; `private`-decl
   resolution gap and/or uncommitted-tree. NOT laundering (verified first-hand). Force a re-run.
5. **Coverage:** blueprint `isZero_modules_of_isEmpty`; consider deleting dead `CechAcyclic.affine`.

## Subagent skips
- strategy-critic / progress-critic / blueprint-reviewer: not review-phase subagents (plan-phase tools);
  not dispatched here.
