# AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

## Summary
- **Declarations added: 1 axiom-clean** — `pushPull_unit_mate` (lines ~298–315).
- **Declarations blocked: 1** — `pushPullMap_comp` (the assigned pentagon law) NOT added.
- **sorry count: 4 → 4** (unchanged: `CechNerve` L89, `CechAcyclic.affine`, `cech_computes_higherDirectImage`,
  `cech_flatBaseChange` — all pre-existing infra-gated). No new sorry, no `pushPullMap_comp` stub left.

## Session summary
- Built axiom-clean: **`pushPull_unit_mate`** — the mate-calculus core of the pentagon. Verified
  `#print axioms` = `{propext, Classical.choice, Quot.sound}`.
- **Key negative finding (important for the planner):** `pushPullMap_comp` is blocked **not** by the mate
  calculus (which is now a one-liner via `pushPull_unit_mate`) but by a **kernel `whnf` blow-up on the
  `eqToHom` over-triangle transports** baked into the definition of `pushPullMap`.

## `pushPull_unit_mate` (RESOLVED — axiom-clean, line ~298)
- **Statement:** for `f : A ⟶ B`, `p : B ⟶ Z`, `N : Z.Modules`,
  `η^p.app N ≫ p_*(η^f.app (p^*N)) ≫ (pushforwardComp f p).hom.app _ = η^{f≫p}.app N ≫ (f≫p)_*((pullbackComp f p).inv.app N)`.
- **Approach:** `unit_conjugateEquiv (adj_p.comp adj_f) adj_{f≫p} (pullbackComp f p).inv N`, then
  `rw [conjugateEquiv_pullbackComp_inv, Adjunction.comp_unit_app]`, then `simpa only [Category.assoc]`.
- **Why it matters:** this is exactly the head-rewrite the pentagon law's unit-splitting needs (turns the
  single-morphism unit `η^{f≫p}` into the iterated `η^p`, `η^f` + the pushforward comparison). Reusable for
  both `pushPullMap_comp` and the Čech-nerve augmentation. **3 lines, fast, kernel-cheap.**

## `pushPullMap_comp` (NOT ADDED — assigned target)
- **Approach 1 (automation):** `simp`/`hom_ext`+sectionwise/`pseudofunctor_associativity` rewrite all FAIL —
  the sectionwise route exposes the full (non-trivial) pullback adjunction unit; the pentagon `rw` needs
  exact pattern shape it never has. Confirmed: no automation shortcut. The hard ingredients
  (`pseudofunctor_associativity`, `conjugateEquiv_pullbackComp_inv`, `pushforwardComp_hom_app_app = 𝟙`
  sectionwise) ALL exist in Mathlib — the difficulty is pure `eqToHom`-transport assembly bookkeeping, so
  there is no clean "missing Mathlib lemma" to extract.
- **Approach 2 (warm-up `pushPullMap_unit`):** I built the augmentation-naturality lemma
  `η^{Y₁} ≫ pushPullMap F k = η^{Y₂}` as a strictly-easier warm-up that exercises the same machinery.
  It reduces **cleanly and fully** to a `unit ≫ eqToHom = unit` collapse via:
  `rw [pushPullMap]; erw [reassoc_of% (pushPull_unit_mate (k.left) Y₁.hom F)];
   erw [Functor.congr_hom (congrArg pushforward (Over.w k)) ((pullbackComp k.left Y₁.hom).inv.app F)]; …`
  — all the categorical logic works (verified goal states step by step).
- **THE BLOCKER (precise):** the final `eqToHom` cancellation **times out the kernel** (`(kernel)
  deterministic timeout`, and elaboration `whnf` timeout even at `maxHeartbeats 1000000`). Cancelling the
  two over-triangle transports forces the kernel to check `defeq` of `pushforward`/`pullback`-applied
  comparison objects, which `whnf`-explodes. Tried: full `simp` (kernel timeout), surgical
  `erw [eqToHom_trans_assoc, …]` (whnf timeout), `backward.isDefEq.respectTransparency false` (no help), and
  a `subst`-based free-variable telescope helper applied by a single `exact` (kernel timeout — the `exact`
  unifies but the kernel can't check the eqToHom defeq). The wall is **intrinsic to the `eqToHom`-heavy
  definition of `pushPullMap`** (the `congrArg (fun q => (pushforward q).obj _) (Over.w g)` transports).
- **Recommended next step (planner):** before re-attempting the pentagon, make `pushPullMap` **transport-light**.
  Either (a) reformulate the def so the over-triangle substitution `g.left ≫ Y₁.hom = Y₂.hom` is absorbed
  WITHOUT `eqToHom` (e.g. via `Over.w`-aware `Functor.mapIso`/`whisker` that the kernel can reduce, or by
  indexing on the structure map as a bundled equality), or (b) prove a **kernel-cheap `eqToHom`-cancellation
  lemma** for the specific `(pushforward q).map ι ≫ eqToHom ≫ (pushforward p).map π ≫ eqToHom` shape that
  does NOT require whnf-ing pushforward objects (the current `subst`-helper is logically correct but the
  KERNEL still re-checks the eqToHom types). The mate calculus itself (`pushPull_unit_mate`) is done.
- **Dead ends — do NOT retry:** sectionwise `hom_ext` (unit not sectionwise trivial); `rw [Over.w k]`
  (motive not type-correct — pullbackComp depends on the composite); `subst (Over.w k)` (circular — `k`'s
  type ties the variables); raising `maxHeartbeats` (kernel timeout is not heartbeat-bounded for the proof
  term, and `whnf` already fails at 1e6).

## Blueprint markers
- `pushPull_unit_mate` is a NEW project-local supplement not in the blueprint's `\lean{}` list; no marker
  needed (it is a helper feeding `lem:push_pull_functor`). `lem:push_pull_functor`'s `pushPullMap_comp`
  remains unformalized — leave its statement-block `\leanok` per the existing `% NOTE (iter-264)` which
  already flags the over-statement. No marker changes by me (prover).
