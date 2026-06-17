# Session 137 — iter-137 review

## Metadata

- **Iteration**: 137 (review of iter-137 prover lane).
- **Stage**: prover (single-file lane on `AlgebraicJacobian/Cotangent/GrpObj.lean`).
- **Sorry count before iter-137**: 5 (per iter-136 close; per-file
  `Cotangent/GrpObj.lean:488 + L610`, `Jacobian.lean:197 + L223`,
  `RigidityKbar.lean:87`).
- **Sorry count after iter-137**: **5** (unchanged — iter-137 was a
  **docstring-only PARTIAL session**; no code or signature changes).
  Line numbers shifted by ~+20/+25 on `Cotangent/GrpObj.lean` due to
  added docstring text. Current per-file:
  - `AlgebraicJacobian/Cotangent/GrpObj.lean:508` (`_basechange_along_proj_two`, Step 2; iter-137 PARTIAL).
  - `AlgebraicJacobian/Cotangent/GrpObj.lean:635` (`mulRight_globalises_cotangent`, Main; iter-138+ target).
  - `AlgebraicJacobian/Jacobian.lean:197` (`genusZeroWitness`, unchanged).
  - `AlgebraicJacobian/Jacobian.lean:223` (`positiveGenusWitness`, unchanged).
  - `AlgebraicJacobian/RigidityKbar.lean:87` (`rigidity_over_kbar`, unchanged).
- **Targets attempted**: 1
  (`AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`).
- **Result**: **PARTIAL** — body remains `sorry`; the iter-137
  mathlib-analogist's prescribed 5-step recipe blocked at Step 2
  (`PresheafOfModules.pullback` chart-opacity gap caught by analogist
  Decision 4); the prover produced a structurally-validated inverse-
  direction-via-adjunction-transpose skeleton (recorded in
  `task_results/Cotangent_GrpObj.lean.md` + the file's L479–L499
  docstring), but did not adopt it inline (adoption would have added
  +1 sorry, exceeding the iter-137 PARTIAL ceiling). 4 docstring sites
  were updated to reflect the PARTIAL outcome + the iter-138+
  closure-path analysis.
- **Files edited**: `AlgebraicJacobian/Cotangent/GrpObj.lean` only —
  4 docstring edits (L427–450, L479–499, L525–527, L616–623). No
  signature changes, no body changes, no new declarations.
- **Cost**: prover lane ~$X / ~16 min / 59 events
  (`meta.json prover.durationSecs: 971`).

## Pre-processed attempt data

`.archon/proof-journal/current_session/attempts_raw.jsonl` contains 59
events, all timestamped 2026-05-18T02:45–03:00Z and consistent with
the iter-137 prover stage. **Fresh** this iter (not stale from a
prior iter). 4 Edit events all on `Cotangent/GrpObj.lean` docstrings;
13 lemma searches; 3 diagnostic checks (all clean); 0 errors.

## Per-target detail

### `relativeDifferentialsPresheaf_basechange_along_proj_two` (`Cotangent/GrpObj.lean:500`) — PARTIAL

**Goal at start (per directive):**

```
Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
  (PresheafOfModules.pullback
      (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
    (Scheme.relativeDifferentialsPresheaf G.hom)
```

The iter-137 mathlib-analogist's 5-step recipe (per
`analogies/kaehler-tensorequiv-presheafpullback.md`):

1. Chart-level `Algebra.IsPushout`-from-affine-product helper (~80–150 LOC).
2. `PresheafOfModules.pullback` chart-unfolding helper (~30–60 LOC).
3. Chart-wise derivation `D_V` (~50–80 LOC).
4. Apply `KaehlerDifferential.lift` (~30–50 LOC).
5. Inverse + `isoMk` assembly (~80–150 LOC).

**Attempt 1 — direct `isoMk` via the 5-step recipe (analogist's prescribed path).**

- **Approach**: assemble the chart-wise `app V : LHS.obj V ≅ RHS.obj V` via
  Steps 1–4 then glue via `PresheafOfModules.isoMk`.
- **Result**: BLOCKED at recipe Step 2. Mathlib defines
  `PresheafOfModules.pullback` as `(pushforward φ).leftAdjoint`, which is
  OPAQUE on `.obj`/`.map`. The Step 2 chart-unfolding helper would itself
  need to be built using `pullbackPushforwardAdjunction` unit/counit
  (~30–60 LOC infrastructure work). Without that helper, `RHS.obj V`
  cannot be expressed concretely, so the `isoMk` `app V` cannot be
  constructed.
- **Dead-end #1**: writing `PresheafOfModules.isoMk` directly fails
  because `app V`'s codomain (`RHS.obj V`) is opaque pre-unfolding.
- **Dead-end #2**: hand-rolling `Iso.mk { hom, inv, hom_inv_id,
  inv_hom_id }` is explicitly forbidden per the iter-137 mathlib-
  analogist Decision 3 (ALIGN_WITH_MATHLIB on `isoMk` for the
  auto-generated `simp` lemmas downstream-consumable by
  `_restrict_along_identity_section`).
- **Insight**: the analogist anticipated this gap (Decision 4); the
  ~30–60 LOC pullback chart-unfolding helper is itself a separable
  infrastructure piece, not body content.

**Attempt 2 — inverse-only direction via `pullbackPushforwardAdjunction` transpose + universal property of `relativeDifferentials' φ_G` + derivation on `(pushforward ψ).obj LHS` (transparent).**

- **Approach (concrete, validated by `lean_run_code`)**:
  ```lean
  noncomputable def basechange_along_proj_two_inv
      (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] :
      (PresheafOfModules.pullback
          (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
        (Scheme.relativeDifferentialsPresheaf G.hom) ⟶
      Scheme.relativeDifferentialsPresheaf (fst G G).left := by
    let ψ := (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom
    let LHS := Scheme.relativeDifferentialsPresheaf (fst G G).left
    let MG := Scheme.relativeDifferentialsPresheaf G.hom
    let D : ((PresheafOfModules.pushforward ψ).obj LHS).Derivation' φ_G := sorry
    let univ_step := (DifferentialsConstruction.isUniversal' φ_G).desc D
    let adj := PresheafOfModules.pullbackPushforwardAdjunction ψ
    exact (adj.homEquiv MG LHS).symm univ_step
  ```
- **Result**: **VALIDATED-AS-COMPILABLE** but NOT adopted in code.
  Adoption would have added +1 sorry to the file's count (on the
  inner derivation `D`), exceeding the iter-137 PARTIAL ceiling
  declared in `PROGRESS.md`. Recorded in
  `task_results/Cotangent_GrpObj.lean.md` for iter-138+ adoption.
- **Insight (load-bearing for iter-138+)**: the route bypasses the
  pullback's chart-opacity by going through the adjunction transpose
  to land on the **transparent** `(pushforward ψ).obj LHS`
  (`pushforward = pushforward₀ ⋙ restrictScalars` with `@[simps]` at
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pushforward:39, 86`).
  The remaining sub-goal is a single ~100–200 LOC pointwise derivation
  construction with Leibniz + `d_app` verifications.

**Attempt 3 — forward direction via universal property of LHS (= `relativeDifferentials' φ'_LHS`) + derivation on RHS.**

- **Approach**: `(DifferentialsConstruction.isUniversal' φ'_LHS).desc D_RHS`.
- **Result**: BLOCKED by the same chart-opacity as Attempt 1.
  Constructing a derivation on `RHS = (pullback ψ).obj M_G` needs
  `RHS.obj V` concretely at each open V — same Step 2 chart-unfolding
  helper requirement. Cannot bypass.
- **Insight**: forward and reverse directions both blocked by the same
  opacity; only the adjunction-transpose route (Attempt 2) escapes,
  and only for the inverse direction.

### Summary table of attempts

| Attempt | Approach | Result | Blocker |
|---|---|---|---|
| 1 | Direct `isoMk` via 5-step recipe | BLOCKED | `pullback` chart-opacity (need ~30–60 LOC `pullbackObjEquivTensor` helper) |
| 2 | Inverse-only via adjunction transpose + universal property + derivation | VALIDATED-AS-COMPILABLE (not adopted; +1 sorry cost) | Derivation construction itself ~100–200 LOC |
| 3 | Forward via universal property of LHS + derivation on RHS | BLOCKED | Same `pullback` opacity as Attempt 1 |

## Side-effect cleanup performed

Per the iter-137 directive's side-effect cleanup list (iter-136
docstring drift items folded into the PARTIAL ship):

- **L506** docstring fix: `(section_snd_eq_identity_struct below)` →
  `above` (helper is at L452, which is above L508's consumer).
- **L596–L597** docstring update: post-PARTIAL state recorded
  (Step 3 closed iter-136; Step 2 PARTIAL iter-137; Main remains `sorry`).
- **L427–L432** section header updated: reflects current Step 3 / Step 2 /
  Main status accurately (replaces stale iter-135 "iter-136+ work"
  placeholder).
- **L474–L478** (now L479–L499) docstring of `_basechange_along_proj_two`
  updated: documents iter-137 PARTIAL state + the universal-property-via-
  adjunction inverse-construction finding + concrete iter-138+ next step.

Skipped (per directive's "Skip if PARTIAL is shipped"):

- L61/L107/L146/L155/L160 file-header line-anchor drift refresh — file
  line numbers aren't stable until Step 2 closes substantively, which
  it did not this iter (extended drift by ~+20/+25 lines).

## Compile state at iter-137 close

- `lean_diagnostic_messages` on `Cotangent/GrpObj.lean` returns 0 errors
  + exactly 2 expected `declaration uses sorry` warnings (L508 = Step 2
  scaffold; L635 = Main scaffold). Both intentional iter-138+ targets.
- `lake env lean AlgebraicJacobian/Cotangent/GrpObj.lean`: clean.
- Total active sorries in `AlgebraicJacobian/`: **5** (per direct grep
  on `AlgebraicJacobian/`):
  - `Cotangent/GrpObj.lean:508` (`_basechange_along_proj_two`, Step 2)
  - `Cotangent/GrpObj.lean:635` (`mulRight_globalises_cotangent`, Main)
  - `Jacobian.lean:197` (`genusZeroWitness`, M2.b scaffold)
  - `Jacobian.lean:223` (`positiveGenusWitness`, M3 user-escalation scaffold)
  - `RigidityKbar.lean:87` (`rigidity_over_kbar`, M2.b scaffold)

## Review-phase audits (subagent dispatches)

Both mandatory audits dispatched and returned cleanly.

- **`lean-auditor-review137`** (4.4 min / $2.38 / 30 turns; report:
  `task_results/lean-auditor-review137.md`). 12 files audited. Verdict:
  **0 must-fix / 0 major / 0 excuse-comments / 6 minor**. All 6 minors
  are cosmetic line-length warnings on non-protected lines (`MayerVietorisCore.lean:438`,
  `AbelJacobi.lean:22`+`:59`, `Cotangent/GrpObj.lean:274`+`:285`,
  `Jacobian.lean:110`+`:119`) or stale forward-references in unrelated
  cohomology docstrings (`MayerVietorisCore.lean:168`,
  `StructureSheafModuleK.lean` L737/L749–750/L781/L803 — references to
  long-closed iter-013/iter-018/iter-019/iter-048 work). Critical
  auditor verdict on the four iter-137 docstring edits:
  > "The new iter-137 docstring prose on `_basechange_along_proj_two`
  > (L479–499) describes the analysis of what an iter-138+ closure path
  > looks like ... It is proof-design analysis attached to an
  > admittedly-`sorry` body, not a 'will fix later'-style admission
  > that conceals the body state. The body state is clearly named."
  Overall: "clean iteration — the four iter-137 docstring edits on
  `Cotangent/GrpObj.lean` describe the partial body state accurately
  without crossing into excuse-comment territory, no new red flags
  introduced, and the five tracked honest-scaffold sorries remain the
  only outstanding `sorry` sites in the project."

- **`lean-vs-blueprint-checker-cotangent-grpobj-review137`** (4.2 min /
  $1.61 / 18 turns; report:
  `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review137.md`).
  One file ↔ one chapter. Verdict: **PASS** — 7 declarations checked,
  0 red flags, **0 must-fix / 0 major / 3 minor**. Per-declaration: all
  7 `\lean{…}`-tagged blocks cross-check cleanly (5 substantively
  closed + 2 honest sorry-scaffolds with intended signatures pinned to
  `\notready` blueprint proof blocks). Minors:
  1. **Blueprint adequacy under-spec on `lem:GrpObj_omega_basechange_proj`
     proof (RigidityKbar L471–480)**: the blueprint's chart-by-chart
     recipe does not anticipate the iter-137-surfaced `PresheafOfModules.pullback`
     chart-opacity blocker. Recommend iter-138 blueprint-writer
     dispatch to add a `% NOTE iter-137:` block (or expanded prose)
     documenting either the chart-unfolding helper route or the
     inverse-direction-via-adjunction-transpose route. The Lean
     docstring at L479–499 is a sufficient interim record.
  2. `_basechange_along_proj_two` signature carries the extra binders
     `{n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
     [GeometricallyIrreducible G.hom]` (L502–503) not required by the
     mathematical statement — minor over-constraint matching the
     consumer's context, deferrable.
  3. `schemeHomRingCompatibility` (Lean L423) lacks a `\lean{...}`
     block in `RigidityKbar.tex` (listed only in the pointer chapter's
     itemize). Coverage cleanup deferrable.
  Blueprint adequacy verdict: **PASS** with one iter-138+ writer
  follow-up (the chart-opacity NOTE).

## Mathlib lemmas / API surface explored this iter (no new substantive use; reconnaissance only)

| Name | Mathlib file | Role |
|---|---|---|
| `PresheafOfModules.pullback` | `ModuleCat/Presheaf/Pullback.lean:44` | OPAQUE on `.obj`/`.map` (= `(pushforward φ).leftAdjoint`) — the iter-137 blocker. |
| `PresheafOfModules.pullbackPushforwardAdjunction` | `Pullback.lean:50` | Adjunction transpose — escape route in Attempt 2. |
| `PresheafOfModules.pushforward` | `Pushforward.lean:86` | TRANSPARENT (= `pushforward₀ ⋙ restrictScalars`, both with `@[simps]`) — the iter-138+ load-bearing piece. |
| `PresheafOfModules.DifferentialsConstruction.isUniversal'` | `Differentials/Presheaf.lean:216` | Universal property for `relativeDifferentials'` — Attempt 2 sub-step. |
| `PresheafOfModules.Derivation'.mk` | `Differentials/Presheaf.lean:157` | Derivation constructor — Attempt 2 sub-goal target. |
| `PresheafOfModules.isoMk` | `Presheaf.lean:118` | Mathlib idiom for assembly (analogist Decision 3 ALIGN_WITH_MATHLIB). |
| `KaehlerDifferential.tensorKaehlerEquiv` | `RingTheory/Kaehler/TensorProduct.lean:249` | Algebra-side chart value identity (recipe Step 3). |
| `TensorProduct.isPushout` | `RingTheory/IsTensorProduct.lean` | Free `Algebra.IsPushout R S T (R⊗ₛT)` (Step 1 chart helper input). |
| `CommRingCat.isPushout_iff_isPushout` | `Ring/Constructions.lean:133` | Bridge `CategoryTheory.IsPushout` ↔ `Algebra.IsPushout` (Step 1). |
| `AlgebraicGeometry.pullbackSpecIso` | `Pullbacks.lean:703` | `Spec(S⊗ₜT) ≅ SpecS ×_SpecR SpecT` (Step 1 chart construction). |

## Blueprint markers updated (manual)

(none this iter)

Rationale:

- No `\mathlibok` candidates (iter-137 was a PARTIAL on a project-
  internal NEEDS_MATHLIB_GAP_FILL-track declaration; no Mathlib
  re-exports).
- No `\lean{...}` renames flagged (no signature changes this iter; the
  per-declaration check report explicitly confirms "no signature drift
  since iter-135" on both still-`sorry` scaffolds at L508 and L635).
- No `\notready` strips warranted — the two iter-137-relevant blocks
  remain correctly `\notready` (statement at RigidityKbar L463, proof
  at L463; main lemma statement at L382, proof at L402; body still
  `sorry`). The iter-136-closed sibling at L527 stays `\leanok` per
  iter-136 marker update.
- The blueprint-checker's MINOR #1 recommendation (`% NOTE iter-137`
  prose-gap acknowledgment on `RigidityKbar.tex` L471–480) is
  **blueprint-writer territory, not review-agent territory** (writing
  a substantive NOTE paragraph that surfaces a new closure-path
  alternative is informal prose, not a marker). Recommended for
  iter-138 plan-phase dispatch. The Lean docstring at L479–L499 is
  the interim record per the checker's own assessment.

## Notes section

- **Per iter-136 progress-critic's next-tier criterion** ("Step 2 closes
  COMPLETE → Route 4 flips UNCLEAR-trending-CONVERGING → CONVERGING"):
  **NOT SATISFIED**. Step 2 returned PARTIAL with structural progress
  (Attempt 2's inverse-direction skeleton validated-as-compilable,
  load-bearing infrastructure gap diagnosed precisely). Per the
  iter-137 plan agent's `iter/iter-137/plan.md` § "Watch criteria
  committed for iter-138" PARTIAL criterion ("ships >50% LOC OR names
  the load-bearing Mathlib lemmas used OR identifies the residual
  sub-piece"): **SATISFIED on the latter two arms** — the prover named
  10 load-bearing Mathlib lemmas + identified the residual sub-piece
  (`pullbackObjEquivTensor` chart-unfolding helper) precisely. Route 4
  stays UNCLEAR-trending-CONVERGING for iter-138 audit.
- **Trigger (a')/(c) LOC arm NOT FIRED**. Iter-137 added 0 LOC of
  body content (docstring-only); cumulative iter-134→iter-137 build on
  (i.b)-side is ~316 LOC (unchanged from iter-136), comfortably inside
  both the iter-134 600-LOC arm (would have fired) AND the iter-137
  renormalised 1000-LOC arm.
- **META-PATTERN TRIPWIRE held**: iter-137 prover lane targeted
  `_basechange_along_proj_two` (piece (i.b) Step 2). Did NOT touch any
  piece (i.a) declaration or the iter-132-closed `cotangentSpaceAtIdentity`
  family.
- **Iter-137 strategic decisions absorbed correctly**: PARTIAL escape
  hatch invoked properly (no fake structural progress shipped; no
  tautological-iso placeholder; honest-scaffold-convention preserved);
  inverse-direction-via-adjunction skeleton documented but NOT
  adopted-in-code per the +1-sorry ceiling constraint; side-effect
  cleanup folded into PARTIAL ship per directive.
- **`current_session/attempts_raw.jsonl` is fresh** this iter (59
  events, all timestamped consistent with the iter-137 prover stage).
- **Prover total cost**: per `meta.json prover.durationSecs: 971` ≈
  16 min; cost ≈ low single digits in $ (single-file PARTIAL session).
- **No new axioms**; `archon-protected.yaml` unchanged (9 protected
  declarations).
