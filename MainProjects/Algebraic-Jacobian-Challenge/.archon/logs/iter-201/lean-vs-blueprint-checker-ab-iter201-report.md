# Lean ↔ Blueprint Check Report

## Slug
ab-iter201

## Iteration
201

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (3101 lines)
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (1182 lines)

---

## Per-declaration

### `\lean{RingTheory.Module.depth}` (chapter: `def:depth`)
- **Lean target exists**: yes — L146–152
- **Signature matches**: yes — `(Ideal R) → (M : Type v) → ℕ∞`, with the `IM = M` branch returning `⊤`, else `sSup` of regular-sequence lengths; matches Stacks 00LF
- **Proof follows sketch**: yes — definition body is the substantive supremum, matching the blueprint's informal description; no sorry
- **notes**: Axiom-clean. `\leanok` on statement block in blueprint is correct.

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: `lem:depth_via_ext`)
- **Lean target exists**: yes — L295–619
- **Signature matches**: yes — `(n : ℕ∞) ≤ depth (maximalIdeal R) M ↔ ∀ i < n, ∀ e : Ext^i(κ, M), e = 0`, encoding the "smallest non-vanishing Ext index" characterisation via a depth-bound iff
- **Proof follows sketch**: yes — both directions of the iff are fully closed; the forward direction (Nakayama-driven sSup extraction + cons-decomposition + LES chase via `ext_smul_eq_zero_of_mem_annihilator`) and backward direction (regular-element extraction + LES-bookkeeping + `le_sSup` assembly) match the blueprint's proof sketch in detail; no sorry
- **notes**: Axiom-clean. The blueprint's proof sketch correctly describes the induction structure and the role of `ext_smul_eq_zero_of_mem_annihilator`. `\leanok` on statement block is correct; proof block should also carry `\leanok` (sync_leanok gap from iter-198 close — outside this report's scope to fix).

### `\lean{Module.projectiveDimension}` (chapter: `def:projective_dimension`)
- **Lean target exists**: yes — L186–188, `namespace Module`
- **Signature matches**: yes — `(R : Type u) → (M : Type u) → WithBot ℕ∞`, one-liner re-export of `CategoryTheory.projectiveDimension (ModuleCat.of R M)`
- **Proof follows sketch**: yes — axiom-clean re-export as described
- **notes**: Correctly placed outside `namespace RingTheory`. Blueprint note about re-export vs re-define is respected.

### `\lean{RingTheory.Module.depth_of_short_exact}` (chapter: `lem:depth_short_exact_sequence`)
- **Lean target exists**: yes — L676–795
- **Signature matches**: yes — takes `f : N' →ₗ N`, `g : N →ₗ N''`, `Injective f`, `Surjective g`, `Exact f g`; returns a conjunction of the three Stacks 00LE inequalities in `min ≤ depth` form
- **Proof follows sketch**: yes — proof packages the LES of `Ext^*(κ, -)` on the SES, using `ext_vanish_of_natCast_lt_depth` (private helper) and `covariant_sequence_exact₂/₃/₁`; matches blueprint's "direct read-off from LES" description; no sorry
- **notes**: Axiom-clean.

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: `thm:auslander_buchsbaum`)
- **Lean target exists**: yes — L1716–1780
- **Signature matches**: yes — `(n : ℕ) → pd R M = n → (n : ℕ∞) + depth(maximalIdeal R) M = depth(maximalIdeal R) R`
- **Proof follows sketch**: partial — the `n = 0` (pd = 0) case is fully closed axiom-clean (finite free → `depth_eq_of_linearEquiv` + `depth_pi_const_eq_depth_of_nonempty`); the `n = k+1` case delegates to `auslander_buchsbaum_formula_succ_pd` which has a `sorry` body
- **notes**: Sorry-propagating via helper; blueprint statement-block `\leanok` is correct (declaration exists); proof block correctly lacks `\leanok`.

### `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}` (chapter: `lem:auslander_buchsbaum_formula_succ_pd`) — ⚠️ MAJOR
- **Lean target exists**: yes — L1639, but **`private lemma`**
- **Signature matches**: yes — `(k : ℕ) → pd R M = k+1 → (k+1 : ℕ∞) + depth(maximalIdeal R) M = depth(maximalIdeal R) R`
- **Proof follows sketch**: N/A — body has a single `sorry` at L1696 (the documented closure-assembly gap)
- **notes**: The `private` modifier means the fully-qualified name `RingTheory.auslander_buchsbaum_formula_succ_pd` is not accessible outside the file. sync_leanok cannot resolve this via `lake env lean` lookup, so the `\leanok` marker on the statement block will likely drift or be incorrectly stripped in future iterations. The blueprint's `% NOTE iter-201` comment at lines 419–436 documents option (1) — remove `private` as part of the closure landing — as the selected resolution, but execution is pending because the body is not yet closed. The sorry itself is expected and documented; the structural issue is the `private` + `\lean{...}` pin combination.

### `\lean{RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular}` (chapter: `lem:depth_drops_by_one`)
- **Lean target exists**: yes — L1020–1123
- **Signature matches**: yes — `{x} → x ∈ maximalIdeal R → IsSMulRegular M x → depth(maximalIdeal R) (QuotSMulTop x M) + 1 = depth(maximalIdeal R) M`
- **Proof follows sketch**: yes — proof goes through LES of `Ext^*(κ, -)` on `0 → M →[x] M → M/xM → 0` using `ext_smul_eq_zero_of_mem_annihilator` and `covariant_sequence_exact₁/₃`; matches blueprint sketch; no sorry
- **notes**: Axiom-clean (iter-198). Blueprint proof block lacks `\leanok` — sync_leanok gap from iter-198, not a prover failure.

### `\lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}` (chapter: `lem:exists_minimalSurjection_finite_localRing`)
- **Lean target exists**: yes — L1198–1276
- **Signature matches**: yes — returns `(n : ℕ) × (f : (Fin n → R) →ₗ M) × (Surjective f) × (n = finrank κ (κ ⊗_R M)) × (ker f ≤ 𝔪 • ⊤)`
- **Proof follows sketch**: yes — uses `Module.finBasis`, `TensorProduct.mk_surjective`, `IsLocalRing.span_eq_top_of_tmul_eq_basis`, and `IsLocalRing.residue_eq_zero_iff` as described; axiom-clean
- **notes**: Axiom-clean (iter-199). `\leanok` on statement and proof blocks in blueprint is consistent.

### `\lean{RingTheory.Module.hasProjectiveDimensionLT_succ_of_projectiveDimension_eq}` (chapter: `lem:hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`)
- **Lean target exists**: yes — L1290–1297
- **Signature matches**: yes — `pd R M = n → HasProjectiveDimensionLT (ModuleCat.of R M) (n+1)`, one-rewrite via `projectiveDimension_lt_iff`
- **Proof follows sketch**: yes — single rewrite, axiom-clean
- **notes**: Axiom-clean (iter-200). `\leanok` on both blocks is correct.

### `\lean{RingTheory.Module.hasProjectiveDimensionLT_ker_of_surjection}` (chapter: `lem:hasProjectiveDimensionLT_ker_of_surjection`)
- **Lean target exists**: yes — L1309–1323
- **Signature matches**: yes — `(f : (Fin n → R) →ₗ M) → Surjective f → HasProjectiveDimensionLT M (k+2) → HasProjectiveDimensionLT (ker f) (k+1)`
- **Proof follows sketch**: yes — builds SES via `LinearMap.shortExact_shortComplexKer`; discharges projectivity of `R^n` via `ModuleCat.projective_of_free`; applies `ShortExact.hasProjectiveDimensionLT_X₁`; axiom-clean
- **notes**: Axiom-clean (iter-200). `\leanok` on both blocks is correct.

### `\lean{RingTheory.Module.hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker}` (chapter: `lem:hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`)
- **Lean target exists**: yes — L1335–1349
- **Signature matches**: yes — companion ascent direction; axiom-clean
- **notes**: Axiom-clean (iter-200). `\leanok` on both blocks is correct.

### `\lean{RingTheory.Module.depth_ker_ge_min_of_surjection_finite_localRing}` (chapter: `lem:depth_ker_ge_min_of_surjection_finite_localRing`)
- **Lean target exists**: yes — L1369–1395
- **Signature matches**: yes — `n ≥ 1 → (f : (Fin n → R) →ₗ M) → Surjective f → Nontrivial (ker f) → min(depth R, depth M + 1) ≤ depth (ker f)`
- **Proof follows sketch**: yes — assembles SES, applies `depth_of_short_exact` part (3), rewrites `depth(R^n) = depth R` via `depth_pi_const_eq_depth_of_nonempty`; axiom-clean
- **notes**: Axiom-clean (iter-200). `\leanok` on both blocks is correct.

### `\lean{RingTheory.CohenMacaulay}` (chapter: `def:cohen_macaulay_local`)
- **Lean target exists**: yes — L1802–1807
- **Signature matches**: yes — `class CohenMacaulay (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R] : Prop` with field `depth_eq_krullDim : (depth(maximalIdeal R) R : WithBot ℕ∞) = ringKrullDim R`
- **Proof follows sketch**: yes — `depth(R) = dim R` encoding; axiom-clean class definition
- **notes**: Axiom-clean. `\leanok` correct.

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: `cor:regular_cohen_macaulay`)
- **Lean target exists**: yes — L3058–3097 (as `instance of_regular`)
- **Signature matches**: yes — `[IsRegularLocalRing R] → CohenMacaulay R`; the blueprint's Corollary statement ("every regular Noetherian local ring is Cohen–Macaulay") is exactly what this instance asserts
- **Proof follows sketch**: yes — uses `exists_isRegular_of_regularLocal` (strong induction on `spanFinrank`) for the lower bound and `length_le_ringKrullDim_of_isRegular` for the upper bound; matches the blueprint's "pick minimal generators as regular sequence + upper-bound via Stacks 00LK" structure; axiom-clean
- **notes**: Axiom-clean. The entire helper chain (`isDomain_of_regularLocal` / `notMem_minimalPrimes_of_regularLocal_succ` / `regularLocal_inductive_step`) is closed, all private. `\leanok` on both blocks is correct.

---

## Red flags

### Placeholder / suspect bodies
- `RingTheory.auslander_buchsbaum_formula_succ_pd` at L1696: body is `:= sorry`. The blueprint has a full lemma block with `\lean{...}` pin and `\leanok`-marked statement. However, this sorry is **documented and expected**: the blueprint's proof block deliberately lacks `\leanok`, the file docstring describes the gap explicitly, and the iter-201 plan noted the sorry as the binding closure-assembly gap. Not a fabricated or weakened statement — the signature is correct and the setup scaffolding (lines 1687–1695) is axiom-clean. **Not a must-fix for its sorry alone; see major finding on `private` modifier below.**

### Excuse-comments
None that excuse wrong or weakened formal content. The comment at L2690–2693 in `isDomain_of_regularLocal` says "its narrow typed sorry the only remaining gap" — this is stale (the referenced helper `notMem_minimalPrimes_of_regularLocal_succ` appears to be fully closed at L2460–2628 via the prime-avoidance route). This stale comment is inside a `private` lemma and does not affect formal correctness; it is documentation drift only.

### Axioms / Classical.choice on non-trivial claims
None introduced. `open Classical` at L148 is confined to the `depth` definition body (the sSup uses `Classical.choice` implicitly via `sSup`, which is standard).

---

## Unreferenced declarations (informational)

The following non-private declarations in the Lean file have no `\lean{...}` pin in the chapter:

- `RingTheory.Module.depth_eq_of_linearEquiv` (L814) — internal substrate for the `pd = 0` base case of `auslander_buchsbaum_formula`; sufficiently covered by `thm:auslander_buchsbaum`'s proof sketch
- `RingTheory.Module.depth_pi_const_eq_depth_of_nonempty` (L988) — internal substrate; same coverage
- `RingTheory.Module.exists_isSMulRegular_of_one_le_depth` (L1136) — utility helper not directly consumed by pinned decls
- `RingTheory.CohenMacaulay.exists_isRegular_of_regularLocal` (L3006) — the non-private helper called by `of_regular`; the iter-185 lean-vs-blueprint-checker flagged adding a `\lean{...}` pin for this (see blueprint `% NOTE` at line 1012). Still missing as of iter-201.

The first three are acceptable as unrefenced helpers. The fourth (`exists_isRegular_of_regularLocal`) is substantive enough to deserve a pin; see Blueprint adequacy section.

---

## Lean → Blueprint: iter-201 new substrate declarations

The four new `private` declarations added in iter-201 (L1397–1519 section header, L1418–1517 actual code):

| Declaration | Lean location | Blueprint reference | Alignment |
|---|---|---|---|
| `Module.elemMap` | L1418–1421 | "E_{ij}" elementary map in Path B recipe (blueprint L932–934) | ✓ aligned |
| `Module.elemMap_apply` | L1424–1435 | Evaluation calculation implicit in "basis-matrix sum" prose | ✓ aligned |
| `Module.linearMap_finFunR_matrix_decomp` | L1440–1468 | "A = Σ_{i,j} A_{ij} · E_{ij}" (blueprint L942) | ✓ aligned |
| `Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator` | L1480–1517 | "zero map" claim at blueprint L934–949 | ✓ aligned |

**No `\lean{...}` pins are expected or present** (all four are `private`). The blueprint prose at lines 929–978 describes the matrix-collapse substrate at the mathematical level and names the proof strategy correctly:
- "A = Σ_{i,j} A_{ij} · E_{ij} (basis-matrix sum)" → `linearMap_finFunR_matrix_decomp`
- "killed by the existing `ext_smul_eq_zero_of_mem_annihilator` (L229)" → actual call at L1517 ✓
- "postcomp distributes" → `mk₀_sum`, `comp_sum`, `mk₀_smul`, `comp_smul` in the Lean proof

**Minor prose-vs-API drift**: The blueprint mentions "Mathlib's `Ext.add_comp` + `Ext.smul_comp` + `Ext.bilinearCompOfLinear`" as the expected API path (blueprint L945–946). The actual implementation uses `mk₀_sum`, `comp_sum`, `mk₀_smul`, `comp_smul` instead. The mathematical content is identical; the API naming differs. Not a semantic mismatch.

**Stale line reference**: Blueprint at L933 says "target site AuslanderBuchsbaum.lean L1290 area". Actual location is L1418+. This is a stale pointer (the L1290 area now houses `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`).

**Body status drift** (the main narrative issue): The blueprint's "Iter-201 Path B closure recipe" paragraph (L892–978) is written entirely in future/recipe tense: "The new matrix-collapse helper (~50--80 LOC, target site ...)" and "The recipe for an iter-201+ prover". However, iter-201 **has landed** all four matrix-collapse substrate declarations, axiom-clean. The blueprint does not note this landing. The inductive-step assembly and matrix-collapse-driven LES bookkeeping in `auslander_buchsbaum_formula_succ_pd` remain open (the sorry at L1696), but the base-case prerequisite is now in hand.

---

## Blueprint adequacy for this file

- **Coverage**: 14/14 `\lean{...}` pins map to existing declarations (one has a `private` modifier issue). Non-private declarations not pinned: 4 (3 acceptable helpers + `exists_isRegular_of_regularLocal` worth pinning per prior iter-185 flag). Private helpers: numerous, expected.
- **Proof-sketch depth**: **adequate**. The proof sketches for `depth_eq_smallest_ext_index`, `depth_of_short_exact`, `auslander_buchsbaum_formula` (base case), and `of_regular` provided sufficient detail for the prover. The Path B recipe at L892–978 is detailed enough to guide the matrix-collapse implementation; the four new declarations align with its description.
- **Hint precision**: **precise** for all 14 active pins. The qualified names in `\lean{...}` match the declared Lean names with correct namespace resolution.
- **Generality**: **matches need** — the chapter correctly identifies the `\leanok` on all closed declarations and leaves proof-block `\leanok` off for declarations with outstanding sorries.

**Recommended chapter-side actions**:
1. **(major, soon)** After removing `private` from `auslander_buchsbaum_formula_succ_pd` (which the iter-201 plan committed to do at closure): no chapter edit needed for this specific item, but the `\lean{...}` pin maintenance will become correct automatically.
2. **(soon)** Update the "Iter-201 Path B closure recipe" paragraph (L892–978) to note that the matrix-collapse substrate has been **landed** in iter-201. Replace future-tense description ("The new matrix-collapse helper ... target site ...") with past-tense landing record. Update the stale line reference (L1290 → L1418).
3. **(minor)** Add `\lean{RingTheory.CohenMacaulay.exists_isRegular_of_regularLocal}` pin to the chapter (previously flagged in iter-185 lean-vs-blueprint-checker report; still missing).
4. **(minor)** The gap table at L575–591 has no row for the Path B matrix-collapse substrate. Optionally add it as a landed item.

---

## Severity summary

### major

**`auslander_buchsbaum_formula_succ_pd` is `private` with an active `\lean{...}` pin.**

The blueprint at L417 pins `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}` and L413 carries `\leanok` on the statement block. Since the declaration is `private` at L1639, `sync_leanok` cannot resolve this qualified name via `lake env lean`. In future iterations when the body closes and `\leanok` should be added to the proof block, sync_leanok will either fail silently or strip the existing statement-block `\leanok`. The plan committed to removing `private` as part of the closure landing (blueprint `% NOTE` L430–436). Until that happens, the `\lean{...}` pin is formally unresolvable. **Downstream impact**: low (this lemma is off-critical-path per file docstring), but sync_leanok integrity is affected.

### soon

**Blueprint Path B narrative describes matrix-collapse substrate as upcoming work, but it has been landed.**

The "Iter-201 Path B closure recipe" paragraph (L892–978) remains in future-recipe tense. The four new private declarations (`elemMap`, `elemMap_apply`, `linearMap_finFunR_matrix_decomp`, `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`) are now present at L1418–1517, axiom-clean. The chapter should be updated to record the landing and separate the "substrate now available" status from the "inductive-step assembly + LES bookkeeping remain" status. Not blocking — the inductive-step assembly (`auslander_buchsbaum_formula_succ_pd` body) is still open — but the chapter narrative is stale.

### minor

- Blueprint L933 line reference "L1290 area" is stale (actual location is L1418+).
- `exists_isRegular_of_regularLocal` (L3006, non-private, substantive) has no `\lean{...}` pin; previously flagged in iter-185 lean-vs-blueprint-checker report, still outstanding.
- Blueprint L945–946 mentions API (`Ext.bilinearCompOfLinear`) that differs from what was actually used (`mk₀_sum`, `comp_sum`, etc.); prose correctly describes the mathematical content but the API path is slightly off.
- Stale comment at L2690–2693 of `isDomain_of_regularLocal` refers to `notMem_minimalPrimes_of_regularLocal_succ` as having "its narrow typed sorry the only remaining gap" — this appears false (the proof is now complete at L2460–2628). Stale documentation inside a `private` helper; no formal impact.

**Overall verdict**: The chapter-Lean pair is in good alignment for all 14 `\lean{...}` pins; the iter-201 matrix-collapse substrate landed as described in the Path B recipe and the four new private declarations match the blueprint's prose description; the one major maintenance item is the `private` modifier on `auslander_buchsbaum_formula_succ_pd` preventing sync_leanok resolution, pending the body-close landing that the plan committed to.
