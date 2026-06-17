# Blueprint Writer Directive

## Slug

rigiditykbar-d-app-d-map-iter141

## Target chapter

`blueprint/src/chapters/RigidityKbar.tex`

## Strategy context

The project's active critical path is M2.body-pile piece (i.b) Step 2
(scheme-level base-change-of-differentials natural iso
`Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}`). The Lean target
`AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`
at `AlgebraicJacobian/Cotangent/GrpObj.lean:670` has 3 sub-sorries in
its Route (b) inverse-direction-via-adjunction-transpose skeleton:

- `d_app` at L624 of `basechange_along_proj_two_inv_derivation` (the
  pointwise derivation's `d_app` field — derivation vanishes on the
  φ_G-image).
- `d_map` at L643 of same (cross-open naturality of the pointwise
  derivation).
- `IsIso` at L689 inside `isIso_of_app_iso_module ... (fun _ => sorry)`
  (per-open ModuleCat-iso check — out of scope this round).

The iter-138 → iter-140 prover lanes returned PARTIAL three times on
these sub-sorries. The iter-141 `blueprint-reviewer-iter141`
identified 3 must-fix items in `RigidityKbar.tex` tied to the active
sub-sorries; the iter-141 `mathlib-analogist-d-app-d-map-iter141`
returned a NEEDS_MATHLIB_LEMMA_NAME verdict on d_map (the missing
name is `PresheafOfModules.pushforward_obj_map_apply'`) and PROCEED
on d_app shape. Your job is to lift the analogist's ground truth into
the chapter so that the iter-142 prover lane has a complete,
factually correct recipe to follow.

## Required content (3 specific updates)

### Update 1: d_app NOTE block — add "Implementation note" naming `ModuleCat.Derivation.d_map`

Locate the d_app NOTE block at `RigidityKbar.tex:602–659`. After
the existing 3-step categorical-chase recipe, add a short
"Implementation note" (~6–10 lines) that:

- Names `ModuleCat.Derivation.d_map`
  (`Mathlib.Algebra.Category.ModuleCat.Differentials.Basic:80`) as
  the algebra-side closing lemma. (NOT `Derivation.map_algebraMap`
  — see below.)
- States the streamlined pattern verified standalone via
  `lean_run_code` (iter-141 d_app/d_map analogist Decision 1):
  ```lean
  example (A B C : CommRingCat) (f1 : A ⟶ B) (g : C ⟶ B) (k : A ⟶ C)
      (hcomm : k ≫ g = f1) (a : A) :
      (CommRingCat.KaehlerDifferential.D g).d (f1.hom a) = 0 := by
    rw [show f1.hom a = g.hom (k.hom a) from by rw [← hcomm]; rfl]
    exact (CommRingCat.KaehlerDifferential.D g).d_map _
  ```
- Notes that this saves ~4 LOC per call site over the
  iter-140-validated `letI : Algebra ... ; letI : Module ... ; letI :
  IsScalarTower ... ; exact (D : Derivation ...).map_algebraMap _`
  chain by packaging the instance-discharge + `map_algebraMap` call
  into `d_map`.
- Estimates ~50–90 LOC for d_app closure (≈ 40–80 LOC for the
  categorical-witness factoring `h` + ~10 LOC for the algebra-side
  discharge via `d_map`).

### Update 2: d_map NOTE block — replace "definitional/transparent" claim with named-lemma + `whnf`-disabled advisory

Locate the d_map NOTE block at `RigidityKbar.tex:661–708`. The
existing text (verbatim, L702–708) reads:

> "The `(pushforward ψ).obj LHS .map f` equals `LHS.map (snd⁻¹f)`
> via the restrictScalars / pushforward₀ transparency
> (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:39, 86`)."

This is **factually incomplete**. The underlying `LinearMap`-level
identity holds, but `pushforward₀_obj` and `pushforward₀` are
annotated `set_option backward.isDefEq.respectTransparency false in`
at `Pushforward.lean:37, 55`, which **explicitly disables** the
`isDefEq` / `whnf`-based unfolding the iter-140 prover's `change`
approach relied on. The iter-140 prover empirically hit a
deterministic `whnf` timeout at `maxHeartbeats=200000` and reverted
the `change` scaffold.

**Replace L702–708 with**:

> "The unfolding `((pushforward ψ).obj LHS).map f =
> LHS.map (snd⁻¹f)` is provided by the explicit `@[simp]`-tagged
> lemma `PresheafOfModules.pushforward_obj_map_apply'`
> (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:99–106`).
> Use `simp only [pushforward_obj_map_apply']` to perform the
> unfolding; do **not** use `change` or other `whnf`-based tactics,
> because `pushforward₀` is annotated
> `set_option backward.isDefEq.respectTransparency false in`
> (`Pushforward.lean:37, 55`) which disables transparency-based
> unfolding (iter-140 prover validated this empirically: `change`
> times out at `maxHeartbeats=200000` on this goal)."

After this replacement, restate the d_map closure as a three-step
ALIGN_WITH_MATHLIB chase (per iter-141 d_app/d_map analogist Decision 4):

1. `simp only [pushforward_obj_map_apply']` for the RHS unfolding.
2. `NatTrans.naturality` for ψ (the natural transformation
   `(Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`, which is
   `(snd G G).left.c` whiskered with `forget₂` per
   `Mathlib.AlgebraicGeometry.Modules.Presheaf:42–45`).
3. `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d`
   (`Presheaf.lean:201–207`) for the universal Kähler derivation
   commutation.

Add an LOC estimate of ~30–50 LOC for d_map closure.

### Update 3: d_map negative-lesson note + IsIso gap-items framing repair

Add a short "Negative-lesson note" at the bottom of the d_map NOTE
block (~4–6 lines) citing the iter-140 prover's `whnf`-timeout
discovery, so future iters do not repeat the `change`-first approach
on `pushforward`-transposed goals. Specifically: "Iter-140 prover
attempted the d_add/d_mul-style `change (CommRingCat.KaehlerDifferential.D _).d _ = _`
approach for d_map; this approach IS valid for d_add/d_mul (where
the RHS is a pure `KaehlerDifferential.D`-applied term) but
deterministically times out for d_map (where the RHS carries
`((pushforward ψ).obj LHS).map f` and the pushforward-transparency
is disabled — see above). The d_map pattern is distinct: use
`simp only [pushforward_obj_map_apply']` first, then naturality +
relativeDifferentials'_map_d."

ALSO update the IsIso "iter-140 prover gap items" list at
`RigidityKbar.tex:917–928`. The current text presents all four
iter-140 gap items as iter-140 targets. iter-140 actually shipped
**item (1) only** — the `isIso_of_app_iso_module` helper at
`Cotangent/GrpObj.lean:544–550`. Items (2)–(4) remain iter-141+
targets. Re-label items (2)–(4) as "iter-141+ targets" and add a
1–2-line update at the top of the list:

> "**Iter-140 update**: item (1), the iso-reflection bridge
> `isIso_of_app_iso_module`, is closed in
> `Cotangent/GrpObj.lean:544–550`. Items (2)–(4) remain iter-141+
> targets. The residual per-open sorry at `Cotangent/GrpObj.lean:689`
> has type `∀ X, IsIso ((basechange_along_proj_two_inv G).app X)`
> (iter-140 narrowed from "whole iso" `letI := sorry` to the per-open
> variant inside `isIso_of_app_iso_module ... (fun _ => sorry)`)."

### Update 4 (small, optional, iter-139 NOTE block staleness)

The NOTE block at `RigidityKbar.tex:491–504` (about the `letI := sorry`
pattern's `sync_leanok` mis-mark concern) cites the iter-138 pattern
shape. iter-140 moved the pattern to `(fun _ => sorry)` inside
`isIso_of_app_iso_module`. Add a brief 1-line update note that the
pattern citation is now dated but the `sync_leanok` concern persists
(sorry is still present in the proof block, so `\leanok` on the proof
block remains a mis-mark candidate until iter-142+ closes the IsIso
sub-sorry).

## Out of scope

- Do NOT touch the IsIso Route (b'2) recipe text at L842–L958. That
  text is current and correct; only the gap-items framing at L917–L928
  needs updating per Update 3.
- Do NOT touch the d_app or d_map blueprint signature stubs or the
  `\lean{...}` blocks. Signature-side is correct.
- Do NOT touch `\notready` markers on statement blocks or `\leanok`
  markers on proof blocks. Those are review-agent / `sync_leanok`
  territory; iter-141 lean-vs-blueprint-checker-iter140 already flagged
  them as informational.
- Do NOT touch any chapter other than `RigidityKbar.tex`.
- Do NOT modify the iter-138/iter-139/iter-140 NOTE blocks beyond
  Updates 3 + 4. The 4-iter accumulation of NOTE blocks is intentional
  and gives future iters traceability.

## References

- `task_results/mathlib-analogist-d-app-d-map-iter141.md` — the
  iter-141 analogist's full verdict. Read this first; it names the
  Mathlib lemmas and the streamlined patterns.
- `analogies/d-app-d-map-recipe-shape.md` — persistent analogy file
  with the design rationale + the standalone-validated `lean_run_code`
  examples.
- `task_results/Cotangent_GrpObj.lean.md` — iter-140 prover task
  result; §"d_app: detailed gap" L68–L108 (factoring-lemma standalone
  validation) + §"d_map: detailed gap" L111–L143 (whnf-timeout
  discovery).
- `task_results/blueprint-reviewer-iter141.md` — the iter-141
  blueprint-reviewer's 3 must-fix items that drive this dispatch.
- `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review140.md` —
  the iter-140 lean-vs-blueprint-checker's stale-marker observations.

## Expected outcome

After your edits land, the d_app NOTE block contains the streamlined
`d_map` algebra-side pattern; the d_map NOTE block contains the
named-lemma + `whnf`-disabled advisory + the three-step chase recipe;
the IsIso gap-items list reflects iter-140 actual progress; the
chapter is ready for the iter-142 prover lane on d_app + d_map sub-
sorries (combined ~80–140 LOC, well within the renormalised 1000 LOC
arm).

The chapter should land `complete: true / correct: true` per the
iter-142 mandatory blueprint-reviewer re-check.
