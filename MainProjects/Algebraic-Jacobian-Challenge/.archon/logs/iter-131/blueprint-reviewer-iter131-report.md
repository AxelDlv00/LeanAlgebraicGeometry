# Blueprint Review Report

## Slug
iter131

## Iteration
131

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / `lem:GrpObj_cotangent_bridge` (line 138, body of the lemma + proof): Lemma statement (line 144) now correctly pins the LHS `𝔤ᵛ := η_G^* Ω_{G/k}` to the iter-130+ chart-base-changed Kähler Lean body, BUT proof Step 1 (line 151) is **still phrased against the iter-128 global-sections framing**: "The iter-128 body of `lem:GrpObj_cotangentSpace` extends scalars of $(\Omega_{G/k})(G)$ along the ring map $\psi \colon \Gamma(G, \mathcal O_G) \to k$ induced by $\eta_G$ on global sections." This is the LHS that the iter-128 body delivered (and was discarded in iter-129 as zero-collapse). The current iter-130 Lean body works with the chart-restricted Kähler module $\Omega_{\Gamma(G, V) \,/\, \Gamma(\Spec k, U)}$ on a chosen affine chart $V \subseteq G.\mathrm{left}$, not with global sections. The localisation step described in Step 1 (`loc : Γ(G, O_G) → O_{G, η_G}` followed by residue `π`) does not match the iter-130 body's `appLE`-based ring map `ηleft.appLE V ⊤ _ ≫ ΓSpecIso.hom : Γ(G.left, V) → k`. A prover dispatched against this proof sketch would attempt a localisation factorisation that has no foothold in the current body.
- `RigidityKbar.tex` / `lem:GrpObj_lieAlgebra_finrank` (rank lemma; line 167): the proof has two staleness defects:
  - Step 1 of the proof (line 191) opens with "By `lem:GrpObj_cotangent_bridge`, the iter-128 evaluate-then-extend-scalars body of `lem:GrpObj_cotangentSpace` is k-linearly isomorphic to …". The phrase "iter-128 evaluate-then-extend-scalars body" is stale by the same drift as above; the iter-130 body is chart-base-changed, not global-section-extended.
  - The "Iter-130 closure path under Replacement (B)" paragraph (line 203) correctly names the chart-base-changed body shape `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V) / Γ(Spec k, U)])` and the closure chain `rank_kaehlerDifferential` + `Module.finrank_baseChange` + `Algebra.TensorProduct.instFree`. BUT this paragraph **does NOT flag** that the actual iter-130 Lean body wraps that ModuleCat term in a `Classical.choice (α := ModuleCat k) ⟨·⟩` `Nonempty` sandwich (Cotangent/GrpObj.lean:143 `refine Classical.choice (α := ModuleCat k) ?_` + line 169 `exact ⟨…⟩`), so `cotangentSpaceAtIdentity G` reduces only to `Classical.choice ⟨baseChangedKaehler⟩`, not to `baseChangedKaehler` directly. A prover dispatched against the line 203 sketch would attempt a direct `Module.finrank_baseChange` rewrite on `cotangentSpaceAtIdentity G`, which fails because `Classical.choice` does not reduce.
- `AbelJacobi.tex` (Section "Universal (Albanese) property", proof body lines 80--82): the "Classical description" half of the proof of `thm:exists_unique_ofCurve_comp` (line 82) still describes the genus-0 reduction as "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ over the algebraic closure …together with Galois descent of morphism equality back to $k$". Per the iter-127 over-k commitment ratified in Jacobian.tex § C.2.f (line 352 explicitly marks Galois descent DROPPED), this prose is stale: rigidity is established directly over $k$ via `thm:rigidity_over_kbar` and no base-change-and-descent step appears anywhere in the M2 critical path. The same staleness recurs in the closing paragraph of AbelJacobi.tex § "Implementation route via the Albanese framework" (line 87: "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ together with Galois descent (genus-0 sub-case)"; line 89: "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ followed by Galois descent").

### Proofs lacking detail

None of the above is "shallow" — they are stale or incomplete-acknowledgment, not under-specified.

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}` (bridge lemma signature stub at line 126--135 comment): the commented-out signature stub still pins `cotangentSpaceAtIdentity G ≅ ModuleCat.of k (Ideal.IsLocalRing.CotangentSpace (R := Scheme.stalk G.left (η_G.left.base ⟨_, trivial⟩)))`. This is mathematically reasonable, but the prover will need to translate "iter-128 body" Step 1 (line 151) into the iter-130 chart-base-change framing before this signature can be closed; until the proof prose is realigned, the `\lean{...}` hint points at a target the proof sketch cannot deliver. **Not in an active prover route this iter** (the directive explicitly defers prover work on `Cotangent/GrpObj.lean` to iter-132), so this is a soon-class finding.

### Multi-route coverage

- Route "M2 via the over-k cotangent-vanishing pile (pieces (i)+(ii)+(iii))": **PARTIAL** — Piece (i.a) lemmas (`lem:GrpObj_cotangentSpace`, `lem:GrpObj_cotangent_bridge`, `lem:GrpObj_lieAlgebra_finrank`) are present in `RigidityKbar.tex`, but the bridge and rank proofs carry the staleness flagged in "Incomplete parts" above. Piece (i.b) (`lem:GrpObj_mulRight_globalises`) and Piece (i.c) (`lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`) are present with `\notready` markers and detailed-enough proof sketches. Piece (ii) (`Scheme.Over.ext_of_diff_zero`) is **not yet blueprint-staged** (per directive: iter-141+ build) — no chapter contains a declaration block for it; only `\cref{sec:RigidityKbar_shared_pile}` lists it as a NEEDS_MATHLIB_GAP_FILL gap. Piece (iii) absolute-Frobenius iteration is similarly unstaged (per directive: iter-144+ build). Piece (iv) Serre duality is DEFERRED as named gap (correct per strategy snapshot).

   Coverage status is consistent with the iter-127 strategy snapshot which schedules pieces (ii) and (iii) for blueprint staging at iter-141+/iter-144+; the absence of those blocks is intentional and not a route-coverage defect.

- Hedge route "ℙ¹-specific rigidity for the $C(k) \neq \emptyset$ branch": MENTIONED but not blueprint-staged (per directive). No coverage defect — strategy snapshot marks it as inactive.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - -

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - -

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - -

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:Scheme_AffineCoverMVSquare_corners` (line 444) has no `\lean{...}` and no `\leanok` because it is a meta-statement subsumed by the four sub-lemmas `_X1`..`_X4` that follow; the four sub-lemmas each carry `\lean{...}` and `\leanok`. Intentional, not a defect.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All five `[verified]` closure pieces in the proof of `thm:smooth_locally_free_omega` (lines 95--100) match the iter-126 mathlib-analogist's name catalogue and the Mathlib b80f227 snapshot. `lem:kaehler_localization_subsingleton` and `lem:kaehler_quotient_localization_iso` survive as standalone PR-quality material per the iter-126 excise; this is consistent with the strategy snapshot.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genus` declared with `\leanok` and the canonical Lean definition `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`; cross-references `def:Scheme_HModule` and `def:Scheme_toModuleKSheaf` resolve.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:GrpObj_eq_of_eqOnOpen` carries `\leanok` and Lean target `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`. Proof sketch (lines 30--49) names four Mathlib ingredients (`ext_of_isDominant_of_isSeparated'`, `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, `Scheme.PartialMap.Opens.isDominant_ι`, `Over.OverMorphism.ext`) and the inferences between them — adequate for a prover.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `lem:GrpObj_cotangentSpace` (line 92): proof has `\leanok`, body is closed in `Cotangent/GrpObj.lean` (no `sorry`). Proof prose at line 115 correctly describes the iter-130 chart-base-change body shape; the "Caveat on canonicity" paragraph at line 121 acknowledges the FIRST `Classical.choice` (chart selection from `smooth_locally_free_omega`) but **does NOT acknowledge** that the actual iter-130 Lean body wraps the result in a SECOND `Classical.choice (α := ModuleCat k) ⟨·⟩` `Nonempty` sandwich (Cotangent/GrpObj.lean:143). The opacity introduced by the second wrapper is the root cause of the rank-lemma blockage flagged in "Incomplete parts".
  - `lem:GrpObj_cotangent_bridge` (line 124): `\notready`. Statement is iter-130-aligned (chart-base-changed LHS pinned at line 144). Proof Step 1 (line 151) describes iter-128 global-sections LHS framing — **stale relative to the iter-130 body**.
  - `lem:GrpObj_lieAlgebra_finrank` (line 166): `\notready`. Step 1 of proof (line 191) refers to "iter-128 evaluate-then-extend-scalars body" — stale. "Iter-130 closure path under Replacement (B)" paragraph (line 203) correctly names the closure chain but **does NOT flag** the `Classical.choice (α := ModuleCat k)` opacity that blocks the rank closure against the iter-130 body shape.
  - `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim` (lines 207, 234, 247): `\notready`. Statements and proofs are detailed-enough for a future prover lane.
  - All `\uses{...}` cross-references in this chapter resolve to existing labels (verified).
  - Iter-127 over-k commitment is consistently reflected in the chapter framing (introduction line 14, Piece (i) line 65, C.2.f-equivalent line removed). The blueprint-writer's iter-130 prose realign that the directive references appears to have successfully shifted Replacement (B) framing into the new lemma statement at line 144 and into the line 115 proof of `lem:GrpObj_cotangentSpace`; the remaining staleness (Step 1 of the bridge proof, Step 1 of the rank proof, line 203 closure path's missing `Classical.choice` flag) is what blocks a downstream rank-lemma prover lane.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All eight Albanese-framework declarations carry `\leanok`. `def:genusZeroWitness` is `\notready` with detailed proof sketch (lines 391--410) including explicit body-closure status note (iter-138+).
  - Sub-step C.2.f explicitly marked DROPPED iter-127 (lines 352--354) and the surrounding C.2.g inventory cleanly enumerates the iter-127 over-k pieces (i)+(ii)+(iii); no internal contradiction.
  - Route A sub-step A.4 (line 275) still mentions "Galois descent" — this is correct in context (Route A internally requires `k = \overline k`); it is NOT the same stale prose as in AbelJacobi.tex. Leave as-is.
  - Mathlib-infrastructure-summary (γ) item (lines 369--372) consistently describes pieces (i)+(ii)+(iii) over arbitrary $k$, correctly matching `RigidityKbar.tex` § "Iter-127 over-k commitment".

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - All three protected declarations (`def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) carry `\leanok` and their Lean targets exist.
  - Stale prose in the "Classical description" half of `thm:exists_unique_ofCurve_comp`'s proof (line 82) and in the closing "Implementation route via the Albanese framework" section (lines 87 + 89): all three locations still describe the genus-0 sub-case as "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ over the algebraic closure …together with Galois descent of morphism equality back to $k$". This is the same iter-127 over-k commitment drift that Jacobian.tex § C.2.f cleanly handled (DROPPED) but AbelJacobi.tex's parallel prose was not realigned. The drift is in "Classical description" remarks, not in any Lean-side proof obligation.

## Cross-chapter notes

- `Jacobian.lean` docstrings at L195--200 ("single remaining mathematical sorry of the Phase-C Jacobian scaffolding…") and L222--230 ("single remaining mathematical sorry of the Phase-C scaffolding") are stale, since `genusZeroWitness` (L188--192, body `sorry`) is now a SEPARATE mathematical sorry. The corresponding chapter prose in `Jacobian.tex` is NOT stale: `def:genusZeroWitness` (line 383) is correctly listed as `\notready` with explicit "Earliest realistic body-closure iteration: iter-138+" (line 410), and Layer~I (line 418) packages the genus-0 arm as `def:genusZeroWitness` separately. So the staleness is on the Lean docstring side only, not the blueprint side; the directive's cross-check resolves as "blueprint prose is consistent; Lean docstrings need a prover-side touch-up the next time `Jacobian.lean` is edited". Not a blueprint defect.
- `RigidityKbar.tex` § Piece (i.a) trio uses the "iter-128 body" phrasing in two places (`lem:GrpObj_cotangent_bridge` Step 1 line 151 + `lem:GrpObj_lieAlgebra_finrank` Step 1 line 191) where it should now read "iter-130 chart-base-changed body". This appears to be a residual from the iter-130 blueprint-writer realign that updated the top-level Replacement (B) framing but did not propagate to the two `\notready` proofs.
- `AbelJacobi.tex` "Galois descent" drift (lines 82, 87, 89) is inconsistent with the iter-127 over-k commitment ratified in `Jacobian.tex` § C.2.f and `RigidityKbar.tex` § "Iter-127 over-k commitment". The two chapters now disagree on whether Galois descent is part of the genus-0 sub-case's classical proof route.

## Strategy-modifying findings (if any)

None. The strategy snapshot (M2 via the over-k cotangent-vanishing pile; piece (iv) deferred) is consistent across the blueprint chapters that should reflect it. The findings above are prose-realignment work, not strategy-modifying.

## Severity summary

Apply these rules verbatim — they decide whether the plan agent dispatches a blueprint-writer this iter or defers.

- **must-fix-this-iter**:
  - `RigidityKbar.tex` is `correct: partial` (bridge proof Step 1 + rank proof Step 1 + rank proof's "Iter-130 closure path" paragraph). Per the canonical severity rule "Any chapter has `correct: partial | false` … must-fix-this-iter", this lands here.
  - `AbelJacobi.tex` is `correct: partial` (Galois-descent prose drift at lines 82, 87, 89). Per the same canonical rule, this also lands here.

  **Directive override note.** The iter-131 plan agent's directive (Focus areas § "RigidityKbar.tex § Piece (i.a) trio") explicitly authorises classifying the two `RigidityKbar.tex` findings as "**must-fix-soon (iter-131 if blueprint-writer dispatched)** rather than must-fix-this-iter", on the rationale that (i) both bridge and rank lemmas carry `\notready` markers and are not on any prover route this iter; and (ii) the iter-131 plan agent has decided to dispatch a refactor lane (not a prover lane) on `Cotangent/GrpObj.lean` this iter to fix the `Classical.choice → Classical.choose`-chain body opacity, and the iter-132 prover lane on the rank lemma is the consumer that requires the proofs to be realigned. The plan agent reads the directive override and may defer the `RigidityKbar.tex` blueprint-writer dispatch to iter-132 (after the refactor lane lands the body-shape fix, so the writer can re-align the proofs against the new body in a single pass). **I flag the findings as must-fix-this-iter per the strict severity rules, and surface the directive override as commentary so the plan agent can apply the override knowingly.**

  `AbelJacobi.tex`'s drift was not flagged by the directive as overridable; per the canonical rule it is must-fix-this-iter regardless. Cost is small (three prose lines to edit). However, no prover lane this iter touches `AbelJacobi.lean`, so deferring to iter-132 carries no concrete cost — the plan agent may exercise the same kind of override and defer the writer dispatch by one iter.

- **soon**:
  - `lem:GrpObj_cotangent_bridge` Lean signature stub (line 126--135): the bridge proof Step 1 must be re-aligned before the bridge declaration can be formalised. Until then, the `\lean{...}` hint points at a target the proof sketch cannot deliver. Not in an active prover route; iter-132+ concern.
  - Pieces (ii) and (iii) blueprint staging is not yet present (per directive: iter-141+/iter-144+ build). Strategy snapshot is internally consistent on this. Soon-class follow-up: when the iter-141+ writer lane lands `Scheme.Over.ext_of_diff_zero` blueprint scaffolding and the iter-144+ writer lane lands absolute-Frobenius blueprint scaffolding, route coverage for pieces (ii) and (iii) flips from PARTIAL/UNSTAGED to PASS.

- **informational**:
  - `Jacobian.lean` docstrings L195+L226 stale "single remaining sorry" count. Lean-side touch-up; not a blueprint-writer concern.
  - `Rigidity.tex` mentions an upstream-PR candidate `ext_of_eqOnNonemptyOpen` (line 67) that the project is not pursuing — historical context, not a defect.
  - `Cohomology_MayerVietoris.tex` and `Cohomology_StructureSheafModuleK.tex` ship `HasCechToHModuleIso` + `HasAffineCechAcyclicCover` carrier classes as deliberately-unproduced producer instances ("Producer status" subsection, MV chapter line 945); this is the project's documented Phase-A endgame and not a defect.

**Overall verdict.** Blueprint is structurally healthy: 8 of 10 chapters are `complete: true, correct: true`. The two `partial` chapters (`RigidityKbar.tex` for residual iter-128/iter-130 prose drift in Piece (i.a) `\notready` lemmas; `AbelJacobi.tex` for stale Galois-descent prose in classical-description remarks) need a blueprint-writer touch-up; the iter-131 directive specifically authorises deferring the `RigidityKbar.tex` writer to iter-132 (after the refactor lane lands the `Classical.choice → Classical.choose`-chain body-shape fix), so the HARD GATE checks pass for the iter-131 refactor lane on `Cotangent/GrpObj.lean` and there is no prover-lane dispatch on `RigidityKbar.lean` or `Cotangent/GrpObj.lean` this iter that would be blocked.
