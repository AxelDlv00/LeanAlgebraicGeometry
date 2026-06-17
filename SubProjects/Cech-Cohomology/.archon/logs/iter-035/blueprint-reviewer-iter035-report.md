# Blueprint Review — iter-035

**Reviewer**: blueprint-reviewer subagent  
**Date**: 2026-06-08  
**Scope**: Whole-blueprint audit + three focused reviews (02KG Cov, P3 tilde-kernels, P1a HARD GATE)

---

## 0. Tools Summary

| Tool | Result |
|---|---|
| `archon blueprint-doctor` | **CLEAN** — no malformed refs, broken refs, orphan chapters, axiom_decls, or covers problems |
| `archon dag-gaps` | 3 uncovered Lean decls (no blueprint entry); 0 broken `\uses{}`; 0 isolated blueprint nodes; 4 ready-to-prove |

**Uncovered Lean declarations** (no blueprint entry):
- `AlgebraicGeometry.CechAcyclic.affine` — lean_aux helper, disposition: **KEEP** (internal, no blueprint obligation)
- `AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf` — iter-034 helper, NOT in any `\lean{}` block → **MUST-FIX** (add to `lem:tilde_preserves_kernels`)
- `AlgebraicGeometry.tilde_stalkFunctor_map_toStalk` — iter-034 helper, NOT in any `\lean{}` block → **MUST-FIX** (add to `lem:tilde_preserves_kernels`)

**Ready to prove** (per dag-gaps, all deps formalized):
- `lem:cech_free_eval_prepend_homotopy` — already part of completed P3b, likely a sync gap
- `lem:modules_restrict_basicOpen` — P1a frontier, **clear to dispatch prover**
- `lem:affine_cech_vanishing_qcoh` — 02KG seed, **clear to dispatch prover**
- `lem:cech_augmented_resolution` — P5b input, **clear to dispatch prover**

---

## 1. Focus Area 1: 02KG Cover-System Cov Correctness

### `lem:affine_surj_of_vanishing` (~L3415–3476)

**Prose verdict: CORRECT. No writer action needed.**

- Statement: "for a distinguished open V and a SES 0→S₁→S₂→S₃→0 with S₁ having vanishing higher Čech cohomology over *standard covers* of V, the section map S₂(V)→S₃(V) is surjective."
- `hvanish` is quantified over "every standard cover U ∈ Cov of V" — covering-only reading, consistent with tightened Cov.
- Proof Step 2 explicitly says "refine {W_α} to a standard cover U = {D(gᵢ)} ∈ Cov of V" via `standard_cover_cofinal`. The covering witness `D(f) = ⨆ D(gᵢ)` is threaded through `standard_cover_cofinal`, which already produces it.
- The `hvanish` re-signing (to pass the covering witness along) is purely a Lean edit; the prose is already at the right level of abstraction.

### `def:affine_cover_system` (~L3714–3755)

**Prose verdict: CORRECT. No writer action needed.**

- Prose: "Cov = standard open covers (finite coverings of a distinguished open by distinguished opens)"
- The covering condition `⨆ᵢ D(gᵢ) = D(f)` is implicit in the phrase "standard open cover" — the prose correctly targets the covering-only Cov.
- The iter-034 `% NOTE` at L3726–3736 explicitly documents: "the Lean `affineCoverSystem.Cov` as currently built (iter-034) is the set of ALL finite basic-open families WITHOUT the covering condition … This prose is the right target; the LEAN must be tightened." This is the correct diagnosis; no prose change is needed.
- The counterexample in the NOTE (`{D(x),D(y)}` on Spec k[x,y] with Ȟ¹(O)≠0) correctly identifies why the over-broad Cov is wrong.

**Action for Lean refactor**: Add the covering condition `⨆ᵢ D(gᵢ) = D(f)` (as a `Finset.sup_eq_top`-style assertion) to `affineCoverSystem.Cov`'s definition, and re-sign `affine_surj_of_vanishing`'s `hvanish` to thread the `Iff.mp` covering witness from `standard_cover_cofinal`'s output. Blueprint requires no edits for this refactor.

---

## 2. Focus Area 2: 01I8 P3 Tilde-Kernels Proof Sketch

### `lem:tilde_preserves_kernels` (~L4327–4398)

**Status**: No `\leanok`. Statement exists; proof open. Two iter-034 helpers built but not referenced.

#### `\lean{}` gap — MUST-FIX THIS ITER

Current `\lean{}` lists:
```
AlgebraicGeometry.tildePreservesFiniteLimits
AlgebraicGeometry.tilde_preservesFiniteColimits
AlgebraicGeometry.tilde_toStalk_map_injective
AlgebraicGeometry.tilde_preservesFiniteLimits_of_preservesKernels
```

**Missing** (confirmed by dag-gaps as uncovered Lean decls):
- `AlgebraicGeometry.tilde_stalkFunctor_map_toStalk`
- `AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf`

Both were built axiom-clean in iter-034 (per memory `p-tilde-exactness-p3.md`). They are the helpers the next prover will use; without them in `\lean{}`, the prover has no blueprint pointer to these tools.

**Recommended `\lean{}` patch**:
```latex
\lean{AlgebraicGeometry.tildePreservesFiniteLimits,
  AlgebraicGeometry.tilde_preservesFiniteColimits,
  AlgebraicGeometry.tilde_toStalk_map_injective,
  AlgebraicGeometry.tilde_preservesFiniteLimits_of_preservesKernels,
  AlgebraicGeometry.tilde_stalkFunctor_map_toStalk,
  AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf}
```

#### Proof sketch gaps — MUST-FIX THIS ITER

The current proof sketch (~L4369–4398) gives:

> (1) Stalks = localizations at primes → stalkwise sufficient for isos; (2) Localization at prime is flat → exact → kernel preserved; (3) comparison map stalkwise iso → iso; generalization to finite limits.

Three sub-steps are missing for the remaining build:

**Sub-step A (R-linearity of the Ab stalk map)**: The sketch says "the comparison map ξ induces, at every point, the isomorphism K_p → Ker(φ_p)." But it does NOT say this isomorphism is R-linear (not just an Ab map). In Lean, the tilde stalk map is an Ab morphism by default; making it into a SheafOfModules morphism requires `germₗ` (the linear version of `germ`). The helper `tilde_stalkFunctor_map_toStalk` (iter-034) provides the stalk-functor naturality; the sketch should name this step explicitly:

> *"The germ map at x is R_p-linear — use `tilde_stalkFunctor_map_toStalk` (which identifies the stalkFunctor action on the tilde functor's morphisms) to confirm the comparison map is a morphism in `(Spec R).Modules`, not merely in Ab."*

**Sub-step B (jointly-reflecting stalk-family → isomorphism of sheaves)**: The sketch says "being a stalkwise isomorphism, the comparison map is an isomorphism of sheaves" in one sentence. In Lean, for a SheafOfModules morphism, the correct tool is the stalk-reflection principle (something like `SheafOfModules.isIso_of_stalkwiseIso` or the Ab-sheaf analogue). The sketch must name the reduction route. If the correct Mathlib lemma name is unknown, add a note: *"search for `isIso_of_stalk` in SheafOfModules or pass through the underlying presheaf comparison."*

**Sub-step C (`tildePreservesFiniteLimits_of_toPresheaf` reduction route)**: The iter-034 helper `tildePreservesFiniteLimits_of_toPresheaf` reduces the finite-limits statement to the underlying presheaf level. The current proof sketch does not mention this reduction; the prover needs to know it exists. Add:

> *"The reduction `tildePreservesFiniteLimits_of_toPresheaf` converts the SheafOfModules finite-limits question to the underlying PresheafOfModules, where the argument is easier (sections-level flatness)."*

#### `\uses{}` — ACCEPTABLE

The lemma block has no `\uses{}`. All upstream facts (stalk = localization, flatness of localization) are Mathlib-backed; no blueprint-level dependency edges are needed. This is correct.

#### Recommended blueprint writer action

This iter, the blueprint writer should:
1. Add `tilde_stalkFunctor_map_toStalk` and `tildePreservesFiniteLimits_of_toPresheaf` to the `\lean{}` hint.
2. Extend the proof sketch with explicit notes for sub-steps A, B, C above (3–5 lines).

---

## 3. Focus Area 3: P1a Restriction Chain — HARD GATE

### `lem:modules_restrict_basicOpen` (~L4012–4041)

**HARD GATE: PASS — dispatch prover.**

| Field | Status |
|---|---|
| Statement | Complete. "Transport F\|_{D(f)} along D(f) ≅ Spec R_f; functorial in F." Clear and correct. |
| `\lean{AlgebraicGeometry.modulesRestrictBasicOpen}` | Present. |
| `\uses{}` | Empty. Correct for a frontier lemma — all deps are Mathlib (the canonical D(f) ≅ Spec R_f affine isomorphism and pullback functoriality). |
| Proof sketch | Adequate. "Pull back along the inverse of D(f) ≅ Spec R_f; restriction and pullback are functorial." Sufficient for a skilled prover. |
| Source citation | Present (`% SOURCE: Tag 01I8`). |
| dag-gaps | Listed as "Ready to prove." ✓ |

**Dispatch: CLEAR.**

---

### `lem:tilde_restrict_basicOpen` (~L4043–4073)

**HARD GATE: PASS** (not dispatched this iter — blocked on `lem:modules_restrict_basicOpen`)

| Field | Status |
|---|---|
| Statement | Complete. "widetilde M\|_{D(f)} ≅ widetilde{M_f}." Correct. |
| `\lean{}` | Present. |
| `\uses{lem:modules_restrict_basicOpen}` | Present, correct single dep. |
| Proof sketch | Adequate. Sections on D(g) ⊆ D(f) are M_{gf} = (M_f)_g; assemble into sheaf iso. |
| Source citation | Present. |

**Dispatch: Ready once `modulesRestrictBasicOpen` closes.**

---

### `lem:presentation_restrict_basicOpen` (~L4076–4116)

**HARD GATE: PASS** (not dispatched this iter — blocked on P1a chain)

| Field | Status |
|---|---|
| Statement | Complete. "If F\|_U has a presentation, F\|_{D(g)} (for basic D(g) ⊆ U) has a presentation over Spec R_g." Correct. |
| `\lean{}` | Present. |
| `\uses{lem:modules_restrict_basicOpen, lem:tilde_restrict_basicOpen}` | Present, correct deps. |
| Proof sketch | Adequate. Restriction of O_X-free modules to D(g) gives O_{D(g)}-free modules via `lem:tilde_restrict_basicOpen`; restriction is right-exact so cokernels survive. |
| Source citation | Present. |

**Dispatch: Ready once tilde_restrict_basicOpen closes.**

---

### `lem:isQuasicoherent_restrict_basicOpen` (~L4118–4162)

**HARD GATE: CONDITIONAL PASS — flag for clarification before dispatch.**

| Field | Status |
|---|---|
| Statement | Complete. "If F is quasi-coherent, F\|_{D(f)} is quasi-coherent over Spec R_f." Correct. |
| `\lean{}` | Present. |
| `\uses{}` | Present and complete (5 deps: `exists_finite_basicOpen_subcover`, `qcoh_iso_tilde_sections_of_presentation`, `modules_restrict_basicOpen`, `tilde_restrict_basicOpen`, `presentation_restrict_basicOpen`). |
| Source citation | Present. |
| Proof sketch | **Under-specified** at one step (see below). |

**Under-specified step**: The proof says "the finitely many local presentations assemble into a presentation of F\|_{D(f)} over Spec R_f." This step is not explained. The prover needs to know whether:
- (a) `IsQuasicoherent` in Lean is defined as "locally isomorphic to widetilde," in which case the local data directly witnesses it and no global presentation assembly is needed (proof simplifies); OR
- (b) `IsQuasicoherent` in Lean carries `SheafOfModules.Presentation` data, in which case assembly of local presentations into a global one requires an explicit argument (e.g., global sections of the cokernel complex, or a dedicated patching lemma).

**Action**: Blueprint writer should clarify which Lean definition of `IsQuasicoherent` the proof targets, and either simplify the proof (if (a)) or add the assembly argument (if (b)). This is not a must-fix for this iter (prover is dispatched only to `modules_restrict_basicOpen`), but must be resolved before the P1a chain reaches this lemma (~2–3 iters out).

---

## 4. Per-Chapter Checklist

### Chapter 1: `Cohomology_HigherDirectImage.tex`

- 1 definition: `def:higher_direct_image` — `\leanok`, `\lean{AlgebraicGeometry.higherDirectImage}`.
- **Status**: COMPLETE. No open items.

### Chapter 2: `Cohomology_AcyclicResolution.tex`

- All declarations axiom-clean (`\leanok` on both statement and proof blocks).
- Key results: `rightDerivedIsoOfAcyclicResolution`, horseshoe lemma, dimension-shift chain — all done.
- **Status**: COMPLETE. No open items.

### Chapter 3: `Cohomology_CechHigherDirectImage.tex` (consolidated chapter)

Covers 10 Lean files. Below is the status by sub-lane.

#### P1–P2 (push-pull, Čech nerve/complex) — COMPLETE
All definitions axiom-clean. No open items.

#### P3 (standard-cover Čech vanishing) — COMPLETE
- `lem:cech_acyclic_affine` and supporting chain: all axiom-clean.
- L1 tilde-bridge, L3 combinatorial homotopy+d²=0, localized-exact: all done.

#### P3b (Čech↔derived bridge) — COMPLETE
- `PresheafCech`, `FreePresheafComplex`, `CechBridge`: all target decls axiom-clean.
- `injective_cech_acyclic`, `ses_cech_h1`, `cechFreeComplex_quasiIso`: done.

#### AbsoluteCohomology + 01EO — COMPLETE
- `jShriekOU`, `absoluteCohomology`, `H⁰≅Γ`, `injective-vanishing`, `LES wrappers`: axiom-clean.
- `cech_eq_cohomology_of_basis` (lem:cech_to_cohomology_on_basis): `\leanok` on statement AND proof. ✓

#### 02KG (affine Serre vanishing) — ACTIVE
| Decl | Status | Note |
|---|---|---|
| `lem:affine_surj_of_vanishing` | `\leanok` | Done |
| `lem:affine_injective_acyclic` | `\leanok` | Done |
| `def:affine_cover_system` | `\leanok` | Cov LEAN fix needed (covering condition); prose correct |
| `lem:affine_cech_vanishing_qcoh` | no `\leanok` | **Ready to prove** (dag-gaps) |
| `lem:affine_serre_vanishing` | no `\leanok` | Blocked on `affine_cech_vanishing_qcoh` + 01I8 qcoh_iso_tilde_sections |

#### 01I8 Route P — ACTIVE (P0 done, P1a in progress, P1b done, P2–P4 unformalized)
| Decl | Status | Note |
|---|---|---|
| `lem:exists_finite_basicOpen_subcover` (P0) | `\leanok` | Done |
| `lem:modules_restrict_basicOpen` (P1a L1) | no `\leanok` | **Ready to prove** → dispatch this iter |
| `lem:tilde_restrict_basicOpen` (P1a L2) | no `\leanok` | Blocked on L1 |
| `lem:presentation_restrict_basicOpen` (P1a L3) | no `\leanok` | Blocked on L1+L2 |
| `lem:isQuasicoherent_restrict_basicOpen` (P1a top) | no `\leanok` | Blocked; proof under-specified (see §3) |
| `lem:isLocalizedModule_of_span_cover` (P1b) | `\leanok` | Done (iter-032) |
| `lem:qcoh_localized_sections` (P1) | no `\leanok` | Blocked on P1a |
| `lem:qcoh_global_generation` (P2) | no `\leanok` | Blocked on P1 |
| `lem:tilde_preserves_kernels` (P3 sub-gap) | no `\leanok` | **`\lean{}` must-fix** (add 2 iter-034 helpers); proof sketch must-fix (3 sub-steps) |
| `lem:qcoh_kernel_qcoh` (P3) | no `\leanok` | Blocked on tilde_preserves_kernels |
| `lem:isIso_fromTildeGamma_of_quasicoherent` (P4) | no `\leanok` | Blocked on P2+P3 |
| `lem:qcoh_iso_tilde_sections` (top) | no `\leanok` | Blocked on P4 |

#### P5a (cech-term acyclicity) — ACTIVE (infrastructure unformalized)
| Decl | Status | Note |
|---|---|---|
| `def:cohomology_sheaf_is_sheafify_homology` | no `\leanok` | P5a engine |
| `lem:higher_direct_image_presheaf` | no `\leanok` | P5a |
| `lem:open_immersion_pushforward_comp` | no `\leanok` | P5a |
| `lem:cech_term_pushforward_acyclic` | no `\leanok` | P5a |
| `lem:cech_augmented_resolution` | no `\leanok` | **Ready to prove** (dag-gaps) |

#### P5b (top comparison) — BLOCKED
| Decl | Status | Note |
|---|---|---|
| `lem:cech_computes_cohomology` | `\leanok` (statement) | TOP GOAL — declaration exists, proof blocked on P5a |

---

## 5. Unstarted Phase Proposals

**None.** All four active phases (02KG, 01I8, P5a, P5b) have adequate blueprint coverage. No new phases are warranted this iter.

---

## 6. Summary of Must-Fix Actions This Iter

| Priority | Location | Action | Owner |
|---|---|---|---|
| **MUST-FIX** | `lem:tilde_preserves_kernels` `\lean{}` | Add `tilde_stalkFunctor_map_toStalk` + `tildePreservesFiniteLimits_of_toPresheaf` | Blueprint writer |
| **MUST-FIX** | `lem:tilde_preserves_kernels` proof sketch | Add sub-steps A (germₗ / R-linearity via `tilde_stalkFunctor_map_toStalk`), B (stalkwise-iso → sheaf-iso: name the Lean primitive), C (`tildePreservesFiniteLimits_of_toPresheaf` reduction route) | Blueprint writer |
| **MUST-FIX** (Lean) | `affineCoverSystem.Cov` | Add covering condition `⨆ᵢ D(gᵢ) = D(f)` to Lean def; re-sign `affine_surj_of_vanishing` `hvanish` | Lean prover / refactor |
| Recommended | `lem:isQuasicoherent_restrict_basicOpen` proof | Clarify which Lean definition of `IsQuasicoherent` is used (locally-tilde vs. global-presentation); simplify or add assembly argument accordingly | Blueprint writer (before P1a concludes) |

**Prover dispatches cleared this iter**:
- `lem:modules_restrict_basicOpen` — **CLEAR** (no deps, proof adequate, Ready to prove)
- `lem:affine_cech_vanishing_qcoh` — **CLEAR** (deps all formalized, proof adequate, Ready to prove)
- `lem:cech_augmented_resolution` — **CLEAR** (deps all formalized, proof adequate, Ready to prove)

---

## 7. Gate Summary for P1a Prover Dispatch

| Lemma | complete | correct | HARD GATE |
|---|---|---|---|
| `lem:modules_restrict_basicOpen` | ✓ | ✓ | **PASS — dispatch** |
| `lem:tilde_restrict_basicOpen` | ✓ | ✓ | PASS (dispatch when L1 closes) |
| `lem:presentation_restrict_basicOpen` | ✓ | ✓ | PASS (dispatch when L2 closes) |
| `lem:isQuasicoherent_restrict_basicOpen` | partial (assembly step under-specified) | ✓ | CONDITIONAL — clarify before dispatch |
