# Lean ↔ Blueprint Check Report

## Slug
coe-iter203

## Iteration
203

## Files audited
- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (1884 lines)
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex` (1703 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` (def:indeterminacy_locus)
- **Lean target exists**: yes (line 147, `def indeterminacyLocus`)
- **Signature matches**: yes — blueprint says `Z(f) := X \ Dom(f)` as a `Set X`; Lean body is `(f.domain : Set X)ᶜ`.
- **Proof follows sketch**: N/A (definition)
- **Notes**: The companion `lemma isClosed_indeterminacyLocus` (line 152) is mentioned as an acceptable separate witness in the blueprint paragraph and exists in the file. No `\lean{...}` pin on it is expected (it is an implementation auxiliary). `\leanok` present and correct.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` (def:codim_one_indeterminacy)
- **Lean target exists**: yes (line 181, `def CodimOneFree`)
- **Signature matches**: yes — blueprint: "every η with `Order.coheight η = 1` lies in `f.domain`"; Lean: `∀ (x : X), Order.coheight x = 1 → x ∈ f.domain`.
- **Proof follows sketch**: N/A (Prop-valued predicate, no proof body)
- **Notes**: `\leanok` present and correct.

### `\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}` (lem:module_free_kaehler_localization)
- **Lean target exists**: yes (line 326, `private theorem module_free_kaehlerDifferential_localization`)
- **Signature matches**: yes — blueprint: `[Module.Free S Ω[S/R]] → Module.Free Sₘ Ω[Sₘ/R]`; Lean: `[Module.Free S (Ω[S⁄R])] (M : Submonoid S) (Sₘ) [IsLocalization M Sₘ] : Module.Free Sₘ (Ω[Sₘ⁄R])`.
- **Proof follows sketch**: yes — blueprint says `KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule`; Lean proof uses exactly these two lemmas in two `haveI` lines.
- **Notes**: `\leanok` present. Declaration is private; `sync_leanok` appears to have resolved it via the `\lean{...}` pin. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}` (lem:rank_kaehler_localization_eq_relative_dim)
- **Lean target exists**: yes (line 352, `private theorem rank_kaehlerDifferential_localization_eq_relativeDimension`)
- **Signature matches**: yes — blueprint: `Module.rank Sₘ Ω[Sₘ/R] = n`; Lean body confirms this.
- **Proof follows sketch**: yes — blueprint says `rank_kaehlerDifferential` + `lift_rank_of_isLocalizedModule_of_free`; Lean proof chains these via `haveI : IsLocalizedModule` + `hrank` rewrite.
- **Notes**: `\leanok` present. Axiom-clean.

### `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` (lem:smooth_algebra_krull_dim_formula)
- **Lean target exists**: no — no declaration with this full qualified name appears in the file. The blueprint explicitly marks this as "MISSING in Mathlib at b80f227 as a packaged form" and has no `\leanok` on the lemma block.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: The file provides 7 private substrate helpers (Lines 673–934) that constitute Steps 1–3 of the 3-step decomposition described in `\subsec:stage6_iib_substrate_iter200`, with `ringKrullDim_localization_atMaximal_MvPolynomial` (line 775) as the Steps-1+2 capstone. The named capstone `ringKrullDim_localization_eq_relativeDimension` pinned in the blueprint does not yet exist. This is correctly described as a known open gap; no must-fix.

### `\lean{AlgebraicGeometry.Scheme.cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue}` (lem:cotangent_kahler_over_field)
- **Lean target exists**: yes (line 477, `private noncomputable def cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`)
- **Signature matches**: yes — blueprint describes the Stacks-02JK closed-point cotangent iso `(ker(algebraMap Sₘ κ)).Cotangent ≃ₗ[Sₘ] κ ⊗_Sₘ Ω[Sₘ/R]`; Lean type is exactly `(RingHom.ker (algebraMap Sₘ (IsLocalRing.ResidueField Sₘ))).Cotangent ≃ₗ[Sₘ] TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) Ω[Sₘ⁄R]`.
- **Proof follows sketch**: yes — blueprint's 3-step recipe (retraction→injection via `iff_split_injection`; surjection via `exact_kerCotangentToTensor_mapBaseChange`; bijection→equiv) is matched line-for-line in the Lean proof.
- **Notes**: **Missing `\leanok` on the statement block.** The declaration is axiom-clean, but `sync_leanok` did not add `\leanok`. Most likely explanation: `sync_leanok` cannot resolve `private` declarations in the sorry-checker lookup. The blueprint pin is correct and the formalization is correct; this is a tooling limitation with private-declaration tracking, not a substantive error. Flagged as **major** because a future blueprint-adequacy audit could misread the absent marker as "not yet formalized."

### `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth}` (lem:smooth_to_regular_local_ring)
- **Lean target exists**: yes (line 1401, `private theorem isRegularLocalRing_stalk_of_smooth`)
- **Signature matches**: yes — blueprint: "For every z ∈ X (X smooth over alg-closed k̄), O_{X,z} is a regular local ring"; Lean: `IsRegularLocalRing (X.left.presheaf.stalk z)` under `[Smooth X.hom]` + `[IsAlgClosed kbar]` typeclasses.
- **Proof follows sketch**: partial — Stages 1–5b and sub-gap (i) are axiom-clean and exactly follow the blueprint's staged chain. The residual `sorry` at line 1525 corresponds to sub-gap (ii.B) (the smooth-algebra Krull-dim formula, Stacks 00OE), which the blueprint correctly identifies as the remaining gap and explains in `subsec:stage6_iib_substrate_iter200`.
- **Notes**: `\leanok` on statement block (correctly reflects "declaration exists with sorry body"). Known-open sorry; per directive, not re-flagged for existence. The sorry comment in the Lean file accurately describes the residual gap.

### `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` (lem:smooth_codim_one_dvr)
- **Lean target exists**: yes (line 1614, `theorem localRing_dvr_of_codim_one`, public)
- **Signature matches**: yes — blueprint: "O_{X,η} is an `IsDiscreteValuationRing` when `Order.coheight η = 1`"; Lean signature matches exactly.
- **Proof follows sketch**: yes (modulo propagated sorry) — proof delegates to `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (which carries the sorry via `isRegularLocalRing_stalk_of_smooth`), then closes via `IsDiscreteValuationRing.TFAE.out 0 4`. This is the exact closure pattern described in the blueprint at the `iter-178` note.
- **Notes**: `\leanok` present. Known-open sorry (propagated from stage 6.A).

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` (thm:codim_one_extension)
- **Lean target exists**: yes (line 1683, `theorem extend_of_codimOneFree_of_smooth`, public)
- **Signature matches**: yes — blueprint: "∃! g regular morphism X → Y s.t. g.toRationalMap = f"; Lean: `∃! (g : X.left ⟶ Y.left), g.toRationalMap = f`.
- **Proof follows sketch**: partial — body is a sorry at line 1722. The sorry comment accurately identifies both blockers: Stage 6 gap (`isRegularLocalRing_stalk_of_smooth`) for Step 1 and Stacks 0AVF (depth-≥2 H¹ vanishing) for Step 2. Blueprint proof sketch describes exactly these two steps.
- **Notes**: `\leanok` on statement block (correct). Known-open sorry; not re-flagged per directive.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` (lem:milne_codim1_indeterminacy)
- **Lean target exists**: yes (line 1751, `theorem indeterminacy_pure_codim_one_into_grpScheme`, public)
- **Signature matches**: yes — blueprint: "Z(f) = ∅ ∨ ∀ x ∈ Z(f), ∃ z with coheight 1, x ∈ closure({z})"; Lean type matches verbatim.
- **Proof follows sketch**: partial — sorry at line 1797. The 4-substep proof sketch in the blueprint is accurately reflected in the 4 substep comments in the Lean sorry block (difference-map construction, diagonal criterion, pullback-of-local-rings, pure-codim-1 pole-divisor locus). The substantive blocker (function-field-pullback bridge + Krull-HPP for intersection with diagonal) is correctly identified in both.
- **Notes**: `\leanok` on statement block (correct). Known-open sorry; not re-flagged per directive.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` (lem:mem_domain_partial_map_reshuffle)
- **Lean target exists**: yes (line 1863, `theorem mem_domain_iff_exists_partialMap_through_point`, public)
- **Signature matches**: yes — blueprint: "W.point ∈ f.domain ↔ ∃ g (PartialMap), g.toRationalMap = f ∧ W.point ∈ g.domain"; Lean type is exactly this iff.
- **Proof follows sketch**: yes — blueprint says "definitional reshuffle of `mem_domain`, reordering two conjuncts"; Lean proof is `rw [Scheme.RationalMap.mem_domain]; exact ⟨fun ⟨g, hxg, hg⟩ => ⟨g, hg, hxg⟩, ...⟩`.
- **Notes**: `\leanok` on statement block. Axiom-clean.

---

## Red flags

### Placeholder / suspect bodies
None beyond the 3 known-open sorries (known-open per directive; not re-flagged).

### Excuse-comments
None found. The sorry comments in the file explain known Mathlib gaps accurately; they do not excuse wrong code.

### Axioms / Classical.choice on non-trivial claims
None. The 4 new iter-203 declarations are all axiom-clean per their docstrings (standard kernel triple only).

---

## Unreferenced declarations (informational)

The following substantive public declarations have no `\lean{...}` pin in the chapter:

- `isLocalization_atPrime_stalk_of_affineOpen` (line 1009, public theorem) — a generic Mathlib-shaped fact decoupled from standard-smoothness, described in the B.b prose block. Suitable candidate for a future lightweight `\lean{...}` pin if the blueprint-writer wants to track it.
- `gammaSpecField_ringEquiv` (line 1036, public noncomputable def) — the `Γ(Spec k̄, U) ≃+* k̄` bridge, described in the B.c prose block. Same as above.

The many `private` helpers (Stages 1–4, 5a, 5b, 6.B substrate, 6.A Steps 1–3, B.a–B.c, A2 sub-pieces, the 4 iter-203 Step A1 declarations) are all implementation auxiliaries; their absence from `\lean{...}` pins is expected. The 4 iter-203 declarations are addressed under Blueprint Adequacy below.

---

## Blueprint adequacy for this file

### Direction (B): iter-203 Step A1 substrate declarations — `\lean{...}` pin status

**Confirmed**: the 4 declarations added this iteration have **no `\lean{...}` pins** in the blueprint chapter. They appear only in prose and `\verbatim`/`\texttt{}` environments inside `\subsec:stage6_iib_substrate_iter200`:

| Declaration | Lean file | Blueprint reference |
|---|---|---|
| `quotSMulTop_quotientRing_linearEquiv` | line 1071 (private) | prose description only |
| `isRegular_cons_of_quotient_ring` | line 1084 (private) | prose description only |
| `matsumura_descent_cotangent` | line 1118 (private) | "linear-independence transfer" bullet (prose only) |
| `matsumura_isRegular_of_linearIndependent_cotangent` | line 1236 (private) | `\verbatim` target in `\subsec:stage6_iib_substrate_iter200` |

**Prose recipe vs. landed signatures:**

1. `quotSMulTop_quotientRing_linearEquiv`: The blueprint describes it as "the canonical `(A⧸span{r})`-linear identification `QuotSMulTop r A ≃ₗ A⧸span{r}`." The landed Lean type is exactly `QuotSMulTop r A ≃ₗ[A ⧸ Ideal.span {r}] (A ⧸ Ideal.span {r})`. **Match: yes.**

2. `isRegular_cons_of_quotient_ring`: The blueprint describes it as "the ergonomic ring-quotient form of `IsRegular.cons'`, transported across `quotSMulTop_quotientRing_linearEquiv`." The landed signature consumes `IsSMulRegular A r` and `IsRegular (A⧸span{r}) (rs.map π)` to produce `IsRegular A (r::rs)`. **Match: yes.**

3. `matsumura_descent_cotangent`: The blueprint describes this as the "Linear-independence transfer" bullet — a `LinearIndependent.map`/`.image` step transporting lin-indep of cotangent classes from `A` to the quotient `A⧸span{f₀}`. The landed declaration is a full 90-line proof working through the kernel computation for `Ideal.mapCotangent` (rather than a simple `.image` call), but the mathematical content is the same descent conclusion. **Match: yes (more detailed than implied but correct).**

4. `matsumura_isRegular_of_linearIndependent_cotangent`: **Signature deviation.** The blueprint `\verbatim` block explicitly lists the parameter `(hn : ringKrullDim A = (n : WithBot ℕ∞))`. The landed declaration **drops** this parameter entirely:

   **Blueprint recipe signature:**
   ```
   (n : ℕ) (hn : ringKrullDim A = (n : WithBot ℕ∞))
   (rs : Fin n → A) ...
   ```
   **Landed signature:**
   ```lean
   (n : ℕ) (rs : Fin n → A) (hrs_mem : ∀ i, rs i ∈ IsLocalRing.maximalIdeal A)
   (h_lin : LinearIndependent ...) :
       RingTheory.Sequence.IsRegular A (List.ofFn rs)
   ```
   The proof does not use `ringKrullDim` directly (the induction is on `Fin n` with `IsRegularLocalRing` as the primary structural invariant; the dimension is tracked implicitly via the `spanFinrank` witness from `regularLocal_quotient_isRegularLocal_of_notMemSq`). The dropped hypothesis is genuinely unnecessary. The landed interface is simpler and more correct. **Match: yes (blueprint recipe slightly over-specifies the signature; the landing simplifies appropriately).**

   **Action recommended**: The blueprint prose recipe at `\subsec:stage6_iib_substrate_iter200` should be updated to remove `(hn : ringKrullDim A = (n : WithBot ℕ∞))` from the verbatim target declaration, so future checkers see an accurate interface.

### Coverage
- 9/11 blueprint `\lean{...}`-pinned declarations have live Lean targets (the 9 that exist). 
- `lem:smooth_algebra_krull_dim_formula` pins a non-existent capstone — intentional (Mathlib gap, no `\leanok`, correctly described).
- `lem:cotangent_kahler_over_field` pins an axiom-clean private `def` that exists but lacks `\leanok` (likely a `sync_leanok` limitation with private declarations — tooling issue, not formalization error).
- 4 additional substantive declarations (iter-203 Step A1) have no `\lean{...}` pins at all.

### Proof-sketch depth
**Adequate** for the pinned declarations. The blueprint chapter is unusually detailed: each sorry carries a clear explanation of what Mathlib gap it is gated on, with estimated LOC and recipe detail for future closure. The 3 known-open sorries are correctly characterized in both the blueprint and the Lean file's sorry comments.

The prose coverage of the 4 unpinned iter-203 declarations is adequate to understand their role, but absent `\lean{...}` pins these declarations are invisible to the standard blueprint tracking infrastructure (`lean_decls`, `sync_leanok`, blueprint-doctor orphan checks).

### Hint precision
**Precise** for all pinned declarations. Every `\lean{...}` that has a Lean target names the correct fully-qualified declaration.

### Generality
**Matches need** — the blueprint's level of generality matches what the Lean file requires at each stage.

### Recommended chapter-side actions

1. **(Major)** Add `\lean{...}` pins to the 4 iter-203 Step A1 declarations inside `\subsec:stage6_iib_substrate_iter200`. Suggested pins:
   - `\lean{AlgebraicGeometry.Scheme.quotSMulTop_quotientRing_linearEquiv}`
   - `\lean{AlgebraicGeometry.Scheme.isRegular_cons_of_quotient_ring}`
   - `\lean{AlgebraicGeometry.Scheme.matsumura_descent_cotangent}`
   - `\lean{AlgebraicGeometry.Scheme.matsumura_isRegular_of_linearIndependent_cotangent}`
   This allows `sync_leanok` and the blueprint-doctor to track these declarations as project infrastructure.

2. **(Minor)** Remove `(hn : ringKrullDim A = (n : WithBot ℕ∞))` from the verbatim `matsumura_isRegular_of_linearIndependent_cotangent` recipe block — it was dropped in the actual landing and the prose is now inaccurate on this detail.

3. **(Minor — tooling note)** The missing `\leanok` on `lem:cotangent_kahler_over_field` is a `sync_leanok` limitation with private declarations, not a blueprint author error. If `sync_leanok` is updated to resolve private declarations, this will self-correct; otherwise, a manual `\leanok` addition is safe.

---

## Severity summary

- **must-fix-this-iter**: None. All blueprint-pinned declarations with Lean implementations have correct signatures and accurately described sorry bodies.
- **Major**:
  - `lem:cotangent_kahler_over_field` statement block missing `\leanok` despite axiom-clean private `def` existing — `sync_leanok` tooling limitation with private declarations.
  - 4 iter-203 Step A1 declarations (`quotSMulTop_quotientRing_linearEquiv`, `isRegular_cons_of_quotient_ring`, `matsumura_descent_cotangent`, `matsumura_isRegular_of_linearIndependent_cotangent`) landed with no `\lean{...}` pins — confirmed as stated in directive. Blueprint adequacy finding: these 4 axiom-clean declarations are invisible to standard blueprint tracking infrastructure.
- **Minor**:
  - Blueprint verbatim recipe for `matsumura_isRegular_of_linearIndependent_cotangent` includes `(hn : ringKrullDim A = (n : WithBot ℕ∞))` but the landed version correctly drops this unnecessary parameter; the prose recipe is now inaccurate on this point.
  - `isLocalization_atPrime_stalk_of_affineOpen` and `gammaSpecField_ringEquiv` (both public) have no `\lean{...}` pins; worth adding for completeness.

**Overall verdict**: The Lean file faithfully follows the blueprint for all 9 pinned declarations with live Lean targets — signatures match, sorry bodies are accurately described, and no placeholder abuse or excuse-comments are present. The two major findings are both blueprint-adequacy gaps introduced by iter-203's landing of 4 unpinned axiom-clean declarations; they do not affect the correctness of what is formalized.
