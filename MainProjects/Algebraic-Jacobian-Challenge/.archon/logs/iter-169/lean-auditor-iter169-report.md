# Lean Audit Report

## Slug
iter169

## Iteration
169

## Scope
- files audited: 1 (`AlgebraicJacobian/Genus0BaseObjects.lean`) — full pass.
- files skimmed for cross-consistency only: 1 (`AlgebraicJacobian/AbelianVarietyRigidity.lean`, the sole downstream consumer of this file) — confirmed no broken reference after the `ga_grpObj` / `ga_smooth` deletion.
- files skipped per directive: 13 (other `.lean` files under `AlgebraicJacobian/`) — not touched this iter and not on the change set per the directive.

Build status (LSP diagnostics): **0 errors**, 8 sorry warnings only — file compiles.

## Per-file checklist

### `AlgebraicJacobian/Genus0BaseObjects.lean`

- **outdated comments**: 1 flagged
- **suspect definitions**: 4 flagged (load-bearing `:= sorry` bodies — the 4 "Mathlib gap"-framed instances re-audited per directive)
- **dead-end proofs**: 1 flagged (`homogeneousLocalizationAwayIso_aux_left` admitted unused; propagates `sorry` into a public iso)
- **bad practices**: 1 flagged (iter-status prose in source docstrings)
- **excuse-comments**: 2 flagged (the iter-169 docstrings on `gmScalingP1` + `gmScalingP1_collapse_at_zero` — see analysis below)
- **notes**:
  - L588 (`gm_grpObj` docstring): "Scaffold body — same discipline as `ga_grpObj`." — `ga_grpObj` was deleted from this file this iter (per directive item SECONDARY-4); the comparison reference is now dangling.
  - L226 `push Not at h`: verified via `lean_multi_attempt` — this is the **current** mathlib idiom; `push_neg` is deprecated in favor of `push Not`. NOT a finding; recording here because the syntax looked suspect on initial read.
  - L685 `gmScalingP1`: `:= sorry`. Load-bearing — directly consumed by `AbelianVarietyRigidity.lean:932,968,991,994,996…`. Body deferred multiple iters now (164→169). The iter-169 docstring (~60 lines, L626-684) documents two concrete blockers (Mathlib TensorProduct `CommRing` instance for `HomogeneousLocalization.Away`; missing relative-Proj iso) and an iter-170 escalation surface.
  - L709 `gmScalingP1_collapse_at_zero`: `:= by sorry`. Strictly downstream of L685; cannot land before that one. Docstring explicitly says so.
  - L593 `gm_grpObj`: `:= sorry`. Load-bearing — consumed transitively by `gm_smooth` (L600) which references `gm_grpObj` in a `have :` and then calls `smooth_of_grpObj_of_isAlgClosed`. This is now in its **3rd-iter deferral** per MEMORY.md `genus0-aux-pile-discharged-iter167.md`.
  - L175, L182, L789, L819: the 4 "Mathlib gap"-framed scaffold sorries — re-audited below.
  - L360 `homogeneousLocalizationAwayIso_aux_left`: `:= by sorry`. **Propagates** through L378 into `homogeneousLocalizationAwayIso`, a public `noncomputable def`. The iter-169 rewrite explicitly admits it's "deferred infrastructure not on the genus-0 critical path", i.e. the iso itself is currently unused. Confirmed by grep: zero consumers of `homogeneousLocalizationAwayIso` across the codebase. **Recommend: if it's truly off-path, either close the body or delete the public iso (and the two aux lemmas) rather than ship a public API with a `sorry` floor.** The current state — public `noncomputable def` whose body relies on a `sorry`-bottomed aux — is the worst combination: it advertises a closed iso while not actually being one.
  - L588 docstring is the *only* place in `AlgebraicJacobian/` that still mentions `ga_grpObj` after deletion. `AbelianVarietyRigidity.lean` does NOT reference `Ga`, `ga_grpObj`, `ga_smooth`, or `GaScheme` — so the deletion is safe at the Lean level.
  - Cross-consistency (out-of-scope info): `blueprint/src/chapters/AbelianVarietyRigidity.tex:1022-1023` still carries `\label{def:ga_grpObj}` + `\lean{AlgebraicGeometry.ga_grpObj}`, and `blueprint/lean_decls:134` still lists `AlgebraicGeometry.ga_grpObj`. These are blueprint-side orphans handled by blueprint-doctor, not by me — flagged here purely so the reviewer can confirm blueprint-doctor catches them.

## Re-audit of the 4 "Mathlib gap"-framed scaffold sorries (per directive)

Mandate: assess whether these genuinely sit on Mathlib gaps or could close in <30 LOC like `projectiveLineBar_isReduced` did at iter-168.

### 1. `projectiveLineBar_geomIrred` (L175) — `GeometricallyIrreducible (ProjectiveLineBar kbar).hom`

**Mathlib API for `GeometricallyIrreducible` (`AlgebraicGeometry/Geometrically/Irreducible.lean`):**
- `class GeometricallyIrreducible`
- `lemma iff_geometricallyIrreducible_fiber`
- `lemma eq_geometrically`

No `of_openCover`, no `of_iso`, no chart-stability lemma. The natural reduction via `iff_geometricallyIrreducible_fiber` is recursive (the fiber over `Spec k̄` is `ℙ¹_{k̄}` again).

**Verdict: genuine Mathlib gap.** Closing this in <30 LOC inside the project would require either upstreaming a `GeometricallyIrreducible.of_openCover` lemma or building the geometric-irreducibility argument from `IrreducibleSpace` + base-change density — neither of which is a precedent in this file. Plan-marked acceptable.

### 2. `projectiveLineBar_smoothOfRelDim` (L182) — `SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom`

**Mathlib API for `SmoothOfRelativeDimension` (`AlgebraicGeometry/Morphisms/Smooth.lean`):**
- `class SmoothOfRelativeDimension`
- `lemma SmoothOfRelativeDimension.smooth` (the projection to `Smooth`)

No `of_openCover` for the relative-dimension variant. `Smooth` itself has cover-stability, but the relative-`1`-dimension witness is the issue: each affine chart `D₊(X i) ≅ 𝔸¹_{k̄}` is smooth of relative dim 1, but knitting the dimension witness across the cover requires infrastructure not visibly present.

**Verdict: genuine Mathlib gap.** Likely >30 LOC even with a custom cover-stability lemma. Plan-marked acceptable.

### 3. `gm_geomIrred` (L789) — `GeometricallyIrreducible (Gm kbar).hom`

Same `GeometricallyIrreducible` API as #1. The natural argument (`k̄[t, t⁻¹] ⊗_{k̄} L = L[t, t⁻¹]` is a domain for any extension `L`) does NOT have a bridging Mathlib lemma; the affine case would need a `GeometricallyIrreducible_Spec_iff_baseChange_isDomain`-style result that the file's docstring on `gm_geomIrred` correctly identifies as missing.

**Verdict: genuine Mathlib gap.**

### 4. `projGm_isReduced` (L819) — `IsReduced ((ProjectiveLineBar kbar) ⊗ Gm kbar).left`

**Closer to the iter-168 precedent.** `IsReduced.of_openCover` exists. The natural cover of the pullback `ℙ¹ × 𝔾_m` is `(D₊(X i) ×_{Spec k̄} 𝔾_m)_{i ∈ Fin 2}`, each chart being `Spec(HomogeneousLocalization.Away 𝒜 (X i) ⊗_{k̄} k̄[t, t⁻¹])`.

The chart ring is a tensor of two integral domains over the field `k̄`. The `IsReduced` of this ring is the only remaining gap. Mathlib has tensor-product-of-NoZeroDivisors results over fields, but I could not locate a directly-citable `Algebra.TensorProduct.isReduced_of_isReduced_of_isReduced_field` (no hits in `mathlib/Mathlib` for `^.*(theorem|lemma|instance).*IsReduced.*Tensor`).

**Verdict: BORDERLINE — closer to a closable lemma than to a true Mathlib gap.** The chart-side strategy described in the docstring (and the precedent of `projectiveLineBar_isReduced` closing at iter-168 in ~30 LOC via `IsReduced.of_openCover`) suggests this *could* close in ~30-60 LOC if the prover were willing to either (a) prove the tensor-of-domains-over-field-is-reduced lemma inline against the concrete `Away 𝒜 (X i)` + `k̄[t, t⁻¹]`, or (b) identify the chart ring with a single localization of a polynomial ring (e.g. `k̄[u, t, t⁻¹]`) which is trivially a domain. The docstring's framing as "Mathlib gap" is more pessimistic than warranted. **Suggest the planner revisit this one specifically** — it is the most plausible target of the four for a near-term close.

## Must-fix-this-iter

Strict auditor rule: `:= sorry` on a load-bearing claim is must-fix-this-iter, regardless of project workflow framing. I am applying the rule. The reviewer / planner has full latitude to defer or accept these per the iter-169 escalation strategy.

- `AlgebraicJacobian/Genus0BaseObjects.lean:175` — `projectiveLineBar_geomIrred := sorry` on a load-bearing instance consumed by Lane B's `morphism_P1_to_grpScheme_const_aux`. Why must-fix: the auditor's strict rule on `:= sorry` for substantive claims; offset by the genuine Mathlib-gap finding above.
- `AlgebraicJacobian/Genus0BaseObjects.lean:182` — `projectiveLineBar_smoothOfRelDim := sorry`, same reasoning.
- `AlgebraicJacobian/Genus0BaseObjects.lean:360` — `homogeneousLocalizationAwayIso_aux_left := by sorry` propagates into the public `homogeneousLocalizationAwayIso` def (L370-378). Why must-fix: the def is publicly exported with a `sorry`-bottomed body but is currently unused — either close the aux or delete/seal the iso, do NOT both ship a public API and leave it unsound. (The iter-169 docstring rewrite acknowledged it as "deferred"; the audit asks for a structural decision rather than indefinite deferral.)
- `AlgebraicJacobian/Genus0BaseObjects.lean:593` — `gm_grpObj := sorry`. Why must-fix: load-bearing for `gm_smooth` (L600) and the entire `𝔾_m`-scaling shortcut; 3rd-iter deferral per MEMORY.md.
- `AlgebraicJacobian/Genus0BaseObjects.lean:685` — `gmScalingP1 := sorry`. Why must-fix: THE pivotal genus-0 morphism; consumed at 7 sites in `AbelianVarietyRigidity.lean`; 5th-iter deferral surface armed per iter-169 plan commitment.
- `AlgebraicJacobian/Genus0BaseObjects.lean:709` — `gmScalingP1_collapse_at_zero := by sorry`. Why must-fix: directly downstream of L685; substantive equational claim consumed in the rigidity helper.
- `AlgebraicJacobian/Genus0BaseObjects.lean:789` — `gm_geomIrred := sorry`. Same auditor rule; offset by the genuine Mathlib-gap finding.
- `AlgebraicJacobian/Genus0BaseObjects.lean:819` — `projGm_isReduced := sorry`. Same auditor rule; **the audit specifically recommends this one for attempt this iter — it is BORDERLINE rather than a genuine Mathlib gap** (see re-audit #4 above).

## Major

- `AlgebraicJacobian/Genus0BaseObjects.lean:588` — `gm_grpObj` docstring's phrase "same discipline as `ga_grpObj`" is now stale after the iter-169 deletion of `ga_grpObj` from this file. Cosmetic but actively misleading.
- `AlgebraicJacobian/Genus0BaseObjects.lean:626-684` and `697-708` — extremely long docstrings (60+ lines each) carrying iter-specific status prose ("Status (iter-169 PARTIAL/escalation)", "Iter-170 escalation surface (per the iter-169 plan's commitment)"). Iter-status framing belongs in `.archon/iter/iter-NNN/` or in commit messages; once landed in source, these docstrings will drift stale within 1-2 iters. Recommend trimming to a stable mathematical description + a single-line `TODO` pointing to the iter log. The current shape encodes plan churn into git history.
- `AlgebraicJacobian/Genus0BaseObjects.lean:819-823` — `projGm_isReduced` docstring claims a "Mathlib gap" (`Smooth → GeometricallyReduced` not bridged). The auditor's re-audit (see #4 above) finds this framing pessimistic: the iter-168 precedent of `projectiveLineBar_isReduced` closing via `IsReduced.of_openCover` applies here with the tensor-of-domains adaptation. Recommend revisiting.

## Minor

- `AlgebraicJacobian/Genus0BaseObjects.lean:585-592` — `gm_grpObj` docstring is technically accurate but very long for a `:= sorry` instance. Once the body lands, much of the prose will need rewriting anyway.
- `AlgebraicJacobian/Genus0BaseObjects.lean:55` — module header's `% archon:covers ... AlgebraicJacobian/Genus0BaseObjects.lean` — verify this `archon:covers` token is what the blueprint-doctor expects; it's a single appearance pattern.
- `AlgebraicJacobian/Genus0BaseObjects.lean:629,684` — repeats of the phrase "iter-169 PARTIAL/escalation" in docstrings; mild redundancy with the surrounding prose.

## Excuse-comments (always called out separately)

The strict definition of "excuse-comment" is a comment that admits the code is wrong (e.g. "temporary", "placeholder", "will fix later"). The iter-169 docstrings on `gmScalingP1` and `gmScalingP1_collapse_at_zero` are NOT pure excuse-comments — they document specific technical obstructions and propose concrete routes (a) chart-glue, (b) relative-Proj iso. However, they DO carry the load-bearing "body remains `sorry` (typed)" admission, and the type's substantive equational/morphism content cannot be silently sorried without weakening the project's claims downstream.

Listing them as borderline excuse-comments for visibility:

- `AlgebraicJacobian/Genus0BaseObjects.lean:626-684` (attached to `gmScalingP1`): "Status (iter-169 PARTIAL/escalation): body remains `sorry` (typed). … Scaffold body retained as typed `sorry` per protocol 'never weaken the type to dodge the proof'." — **Severity: major.** This is honest about the gap but is the 5th-iter deferral on this specific body.
- `AlgebraicJacobian/Genus0BaseObjects.lean:697-708` (attached to `gmScalingP1_collapse_at_zero`): "Status (iter-169 PARTIAL/escalation): body remains `sorry`, gated on `gmScalingP1`'s own body landing." — **Severity: major.** Honest, gated on the upstream body, but still a `sorry` on a substantive lemma.
- `AlgebraicJacobian/Genus0BaseObjects.lean:172-184` (the comment block above the 2 `projectiveLine` scaffold sorries): "Project-side scaffold sorry (Mathlib does not ship …; plan-marked acceptable for iter-165)." — **Severity: minor.** Stale iter reference (iter-165) on something that's now iter-169.
- `AlgebraicJacobian/Genus0BaseObjects.lean:807-818` (the comment block above `projGm_isReduced`): "Mathlib gap: the `Smooth → GeometricallyReduced` bridge is missing at scheme level …". **Severity: major** because the re-audit (#4 above) finds the "gap" framing pessimistic — this looks closable in this iter via the iter-168 precedent.

## Severity summary

- **must-fix-this-iter**: 8 — all `:= sorry` bodies on load-bearing declarations under the strict auditor rule. Of these, **3 carry concrete Mathlib gaps** (L175, L182, L789 — `GeometricallyIrreducible` / `SmoothOfRelativeDimension` API is too sparse) and **the remaining 5 do not**:
  - L360 (admitted unused — structural decision needed),
  - L593 (3rd-iter deferral on the genuinely closable `GrpObj.ofRepresentableBy` route per MEMORY.md `genus0-aux-pile-discharged-iter167`),
  - L685 + L709 (the genus-0 critical-path pair, 5th-iter deferral; escalation surface armed per iter-169 plan),
  - L819 (borderline — likely closable via the iter-168 `IsReduced.of_openCover` precedent).
- **major**: 3 — stale `ga_grpObj` cross-reference, iter-status prose in docstrings (×2 spots), pessimistic-gap framing on `projGm_isReduced`.
- **minor**: 3 — stale "iter-165" reference, prose redundancy, `archon:covers` token verification.
- **excuse-comments**: 4 (counted under must-fix-this-iter and major above; flagged separately because they document the project's deferral posture in-source).

Overall verdict: The iter-169 change set itself is **clean and bookkeeping-correct** — the docstring refreshes (SECONDARY-1/2/3) and the `ga_grpObj` / `ga_smooth` deletions are consistent at the Lean level (no broken references in the rest of `AlgebraicJacobian/`), and `push Not` is mathlib-current. The **persistent risk** is the 8 load-bearing `sorry`s on declarations that are increasingly deeply deferred (3rd-, 4th-, and 5th-iter); under the strict auditor rule these are must-fix every iter they persist, and the BORDERLINE one (`projGm_isReduced` L819) is the most plausible candidate for a near-term close based on the iter-168 precedent rather than a true Mathlib gap.
