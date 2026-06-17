# Lean ↔ Blueprint Check Report

## Slug
coe-iter202

## Iteration
202

## Files audited
- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`

---

## Per-declaration: `\lean{...}` blocks in the chapter

The chapter carries 11 `\lean{...}` pins. Per-declaration results:

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` (def:indeterminacy_locus)
- **Lean target exists**: yes (L146)
- **Signature matches**: yes — `def indeterminacyLocus ... : Set X := (f.domain : Set X)ᶜ` — matches "closed complement of Dom(f)".
- **Proof follows sketch**: yes / N/A (definition, one-liner complement)
- **notes**: Axiom-clean. `isClosed_indeterminacyLocus` exists as an additional standalone lemma (L151), consistent with blueprint text's "or as a standalone lemma".

### `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` (def:codim_one_indeterminacy)
- **Lean target exists**: yes (L180)
- **Signature matches**: yes — `def CodimOneFree ... : Prop := ∀ (x : X), Order.coheight x = 1 → x ∈ f.domain` — matches blueprint's `Order.coheight η = 1 → η ∈ f.domain` encoding.
- **Proof follows sketch**: N/A (definition)
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}` (lem:module_free_kaehler_localization)
- **Lean target exists**: yes (L325, private)
- **Signature matches**: yes — localisation of free Kähler differentials remains free; matches blueprint's Stage 5a content via `KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule`.
- **Proof follows sketch**: yes — proof exactly follows the two-step blueprint sketch.
- **notes**: Axiom-clean, private helper. Blueprint \leanok present.

### `\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}` (lem:rank_kaehler_localization_eq_relative_dim)
- **Lean target exists**: yes (L351, private)
- **Signature matches**: yes — `Module.rank Sₘ (Ω[Sₘ⁄R]) = n` under `IsStandardSmoothOfRelativeDimension n R S`. Matches blueprint Stage 5b statement.
- **Proof follows sketch**: yes — composes `rank_kaehlerDifferential` with `lift_rank_of_isLocalizedModule_of_free` exactly as sketched.
- **notes**: Axiom-clean.

### `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` (lem:smooth_algebra_krull_dim_formula, Stage 6.A)
- **Lean target exists**: no — no declaration with this name exists in the file. The file has `ringKrullDim_localization_atMaximal_MvPolynomial` (L774) as the polynomial-ring-specific Step 1+2 capstone, and `ringKrullDim_quotient_localization_MvPolynomial_of_regular` (L922) as the conditional composite, but neither carries the blueprint-pinned name `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`.
- **Signature matches**: partial — the polynomial-ring capstone covers part of the statement but not the full Stacks-00OE scope.
- **Proof follows sketch**: no — the full Stage 6.A conclusion remains sorry-gated in `isRegularLocalRing_stalk_of_smooth` (L1262 sorry). The pre-existing sorry is UNCHANGED this iter (as expected).
- **notes**: Pre-existing gap; not new this iter. The `\lean{...}` pin name does not match any existing declaration — the plan agent should update or detach this pin if the planned Step 3 lands under a different name.

### `\lean{AlgebraicGeometry.Scheme.cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue}` (lem:cotangent_kahler_over_field, Stage 6.B)
- **Lean target exists**: yes (L476, private noncomputable def)
- **Signature matches**: yes — provides `(RingHom.ker (algebraMap Sₘ κ)).Cotangent ≃ₗ[Sₘ] TensorProduct Sₘ κ Ω[Sₘ⁄R]` under `[FormallySmooth R Sₘ] [FormallySmooth R κ] [Subsingleton Ω[κ⁄R]]`.
- **Proof follows sketch**: yes — the 3-step analogist recipe (retraction→injection via `iff_split_injection`; exactness+Ω=0→surjection; `ofBijective`) is faithfully executed.
- **notes**: Axiom-clean (iter-199).

### `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth}` (lem:smooth_to_regular_local_ring)
- **Lean target exists**: yes (L1138, private)
- **Signature matches**: yes — `IsRegularLocalRing (X.left.presheaf.stalk z)` under `[Smooth X.hom] [IsAlgClosed kbar] ...`.
- **Proof follows sketch**: partial — the 6-stage chain is scaffolded (Stages 1–5b, 6.B-RHS, 6.B-LHS all landed axiom-clean), but the sole remaining `sorry` at L1262 reflects the open Stacks-00OE sub-gap (ii.B): the smooth-algebra Krull-dim formula. UNCHANGED this iter.
- **notes**: Pre-existing sorry; expected.

### `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` (lem:smooth_codim_one_dvr)
- **Lean target exists**: yes (L1351, public theorem)
- **Signature matches**: yes — `IsDiscreteValuationRing (X.left.presheaf.stalk z)` under smooth+integral+coheight=1. Matches blueprint statement.
- **Proof follows sketch**: yes — delegates to `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (which absorbs the `isRegularLocalRing_stalk_of_smooth` sorry) then concludes via `IsDiscreteValuationRing.TFAE`. Blueprint proof sketch is followed faithfully.
- **notes**: Axiom-clean modulo the named `isRegularLocalRing_stalk_of_smooth` sorry.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` (thm:codim_one_extension)
- **Lean target exists**: yes (L1420, public theorem)
- **Signature matches**: yes — `∃! (g : X.left ⟶ Y.left), g.toRationalMap = f` under smooth source, proper target, `CodimOneFree f`. Matches blueprint.
- **Proof follows sketch**: no (sorry at L1459) — UNCHANGED this iter.
- **notes**: Pre-existing sorry; expected. The proof comment accurately explains the two gating gaps (Stacks 0AVF and Stage 6).

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` (lem:milne_codim1_indeterminacy)
- **Lean target exists**: yes (L1488, public theorem)
- **Signature matches**: yes — `indeterminacyLocus f = ∅ ∨ ∀ x ∈ indeterminacyLocus f, ∃ (z : X.left), Order.coheight z = 1 ∧ x ∈ closure ({z} : Set X.left)`. Faithfully captures "empty or pure codim-1".
- **Proof follows sketch**: no (sorry at L1534) — UNCHANGED this iter.
- **notes**: Pre-existing sorry; expected. The proof comment documents the 4-substep plan and the two gating Mathlib gaps.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` (lem:mem_domain_partial_map_reshuffle)
- **Lean target exists**: yes (L1577+, public theorem in `namespace RationalMap`)
- **Signature matches**: yes — iff between `W.point ∈ f.domain` and existence of a PartialMap representative containing `W.point`.
- **Proof follows sketch**: yes — blueprint describes it as "definitional reshuffle"; the Lean proof is the standard unfold.
- **notes**: Axiom-clean.

---

## Focus: the 4 new §3.B bridges (iter-202)

### B.a: `exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension` (private, L994)

**Lean statement:**
```lean
private theorem exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    {n : ℕ} [h : Algebra.IsStandardSmoothOfRelativeDimension n R S] :
    ∃ (ix sx : Type), ∃ (_ : Finite sx) (_ : Finite ix),
      ∃ P : Algebra.SubmersivePresentation R S ix sx, P.dimension = n :=
  h.out
```

**Body**: `h.out` — 1-line re-export of the structure field `Algebra.IsStandardSmoothOfRelativeDimension.out`. Axiom-clean. Not a trivial or weakened statement: it provides an explicit `SubmersivePresentation` with the dimension witness `P.dimension = n`.

**Is it a "fake substrate" masquerading as something more?** No. The declaration does exactly what the §3.B description says: gives Step B.d (and eventually iter-203 Step A1) direct access to the underlying submersive presentation `P` and its dimension. The body is non-trivial (it unpacks the Mathlib class structure) but short.

**Blueprint coverage:** None — no `\lean{...}` pin exists, no §3.B section in the blueprint. Acceptable as a `private` helper-only declaration.

---

### B.b: `isLocalization_atPrime_stalk_of_affineOpen` (public, L1008)

**Lean statement:**
```lean
theorem isLocalization_atPrime_stalk_of_affineOpen
    {X : Scheme.{u}} {V : X.Opens} (hV : IsAffineOpen V) (z : X) (hzV : z ∈ V) :
    letI := TopCat.Presheaf.algebra_section_stalk X.presheaf ⟨z, hzV⟩
    IsLocalization.AtPrime (X.presheaf.stalk z) (hV.primeIdealOf ⟨z, hzV⟩).asIdeal :=
  hV.isLocalization_stalk ⟨z, hzV⟩
```

**Body**: 1-line re-export of `IsAffineOpen.isLocalization_stalk`. Axiom-clean. The statement is a generic, reusable Mathlib-shaped fact (the stalk at an affine-open point is the localisation at the corresponding prime) decoupled from standard-smoothness.

**Is it over-weak or trivially true?** No. `IsLocalization.AtPrime` is a substantive typeclass.

**Blueprint coverage:** MISSING. This is a `public` theorem (no `private`) named in the `AlgebraicGeometry.Scheme` namespace. No `\lean{...}` pin exists in the blueprint, and no §3.B section was added to the blueprint this iter. Since it is public and reusable (the docstring says "a future in-file or cross-file consumer may want"), it warrants a blueprint block.

---

### B.c-1: `open_eq_top_of_subsingleton` (private, L1019)

**Lean statement:**
```lean
private lemma open_eq_top_of_subsingleton {X : Scheme.{u}} [Subsingleton X]
    (U : X.Opens) (hU : Nonempty U) : U = ⊤ := by
  obtain ⟨⟨x, hx⟩⟩ := hU
  ext y
  simp only [TopologicalSpace.Opens.coe_top, Set.mem_univ, iff_true]
  rwa [Subsingleton.elim y x]
```

**Body**: 4-line proof using `Subsingleton.elim`. Axiom-clean. Substantive (not `rfl` or `True`).

**Blueprint coverage:** None — acceptable as a `private` helper-only declaration. The §3.B section describes it as "helper for B.c" (the `subst` step in `gammaSpecField_ringEquiv`).

---

### B.c-2: `gammaSpecField_ringEquiv` (public noncomputable def, L1035)

**Lean statement:**
```lean
noncomputable def gammaSpecField_ringEquiv (kbar : Type u) [Field kbar]
    (U : (Spec (.of kbar)).Opens) (hU : Nonempty U) :
    Γ(Spec (.of kbar), U) ≃+* kbar := by
  have h : U = ⊤ := open_eq_top_of_subsingleton U hU
  subst h
  exact (Scheme.ΓSpecIso (.of kbar)).commRingCatIsoToRingEquiv
```

**Body**: 3-line proof via `open_eq_top_of_subsingleton` + `Scheme.ΓSpecIso`. Axiom-clean. Provides the ring isomorphism `Γ(Spec(.of kbar), U) ≃+* kbar` for any nonempty open `U`.

**Is it over-weak or trivially true?** No. `RingEquiv` is substantive. The non-triviality is the `ΓSpecIso` ingredient.

**Blueprint coverage:** MISSING. This is a `public` definition (no `private`) named in the `AlgebraicGeometry.Scheme` namespace. No `\lean{...}` pin exists. No §3.B section in the blueprint. This is the "Γ(Spec(.of k̄), U) = k̄ definitional bridge" described in the Lean docstring as important for identifying the algebraically-closed base ring of the standard-smooth presentation. It should be blueprint-pinned.

---

## Red flags

### Placeholder / suspect bodies
*None in the 4 new §3.B bridges.* All 4 have substantive, axiom-clean proof terms with no `sorry`, no `Classical.choice _` on non-trivial claims, no `:= True`, no `:= rfl` on non-trivial goals.

### Excuse-comments
*None in the §3.B section.* No "TODO replace", "placeholder", "wrong but works" comments in lines 959–1041.

### Axioms / Classical.choice on substantive claims
*None new.* The 4 bridges do not introduce new `axiom` declarations. (The 3 pre-existing sorries at L1262, L1459, L1534 are unchanged.)

---

## Unreferenced declarations (informational)

The following §3.B declarations are in the Lean file but have no `\lean{...}` blueprint pin:

| Declaration | Visibility | Severity of missing pin |
|---|---|---|
| `exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension` | `private` | acceptable (helper) |
| `isLocalization_atPrime_stalk_of_affineOpen` | **public** | **major** |
| `open_eq_top_of_subsingleton` | `private` | acceptable (helper) |
| `gammaSpecField_ringEquiv` | **public** | **major** |

The many other `private` substrate theorems (Stage 2–6 chain helpers, iter-200–201 Stacks-00OE/A2 substrate) remain unreferenced by the blueprint; all are `private`, so they are acceptable as helpers.

---

## Blueprint adequacy for this file

### Coverage
11 `\lean{...}` pins in the chapter. Of these:
- 10 have corresponding declarations in the Lean file with matching signatures.
- 1 (`Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`) has no matching Lean declaration (the name does not appear in the file; the closest are the polynomial-ring-specific private helpers `ringKrullDim_localization_atMaximal_MvPolynomial` and `ringKrullDim_quotient_localization_MvPolynomial_of_regular`). This is a pre-existing pin mismatch, not new this iter.

Additionally:
- 2 public §3.B declarations lack any blueprint block.

### Proof-sketch depth
**Adequate** for most items; the pre-existing Stage 6 sub-gap recipe blocks are detailed. **Under-specified** for the 4 new §3.B bridges: the blueprint has **no §3.B section at all** — the bridges are introduced in the Lean file with no corresponding blueprint prose.

### Hint precision
**Wrong / stale** in the iter-203 Step A1 recipe block (subsection `§ Stage 6.A iter-200 substrate`, roughly at \texttt{subsec:stage6\_iib\_substrate\_iter200}): the two cross-file helper names are namespaced incorrectly:

| Blueprint prose (wrong) | Correct fully qualified name |
|---|---|
| `RingTheory.isDomain_of_regularLocal` | `RingTheory.CohenMacaulay.isDomain_of_regularLocal` |
| `RingTheory.regularLocal_quotient_isRegularLocal_of_notMemSq` | `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq` |

**Verification:** `namespace CohenMacaulay` opens at `AuslanderBuchsbaum.lean:2154` inside `namespace RingTheory` (open at line 192). Both `regularLocal_quotient_isRegularLocal_of_notMemSq` (line 2626) and `isDomain_of_regularLocal` (line 2990) fall inside the `CohenMacaulay` block (which closes at line 3431). The un-namespaced `RingTheory.isDomain_of_regularLocal` name does not resolve to anything; an iter-203 prover following the recipe verbatim will get a `unknown identifier` error.

### Generality
Matches need for the declared declarations. The §3.B bridges are deliberately generic (decoupled from standard-smoothness) which is appropriate for re-use.

### Recommended chapter-side actions (for blueprint-writing subagent)

1. **[must-fix]** In `subsec:stage6_iib_substrate_iter200`, correct the two wrong names in the Step A1 recipe:
   - `\texttt{RingTheory.isDomain\_of\_regularLocal}` → `\texttt{RingTheory.CohenMacaulay.isDomain\_of\_regularLocal}`
   - `\texttt{RingTheory.regularLocal\_quotient\_isRegularLocal\_of\_notMemSq}` → `\texttt{RingTheory.CohenMacaulay.regularLocal\_quotient\_isRegularLocal\_of\_notMemSq}`
   This correction also applies to the inline recipe code block at `\begin{verbatim}` lines that call these names.

2. **[major]** Add a `§3.B` blueprint subsection (or paragraph under `subsec:stage6_iib_substrate_iter200`) documenting the 4 iter-202 Stage-6 scheme-to-algebra bridges with `\lean{...}` pins for the 2 public ones:
   - `\lean{AlgebraicGeometry.Scheme.isLocalization\_atPrime\_stalk\_of\_affineOpen}`
   - `\lean{AlgebraicGeometry.Scheme.gammaSpecField\_ringEquiv}`
   The 2 private ones do not need `\lean{...}` pins but a brief description of what B.a–B.c deliver as a group suffices.

3. **[minor]** The pin `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim\_localization\_eq\_relativeDimension}` at `lem:smooth_algebra_krull_dim_formula` is stale: no Lean declaration with that name exists in the file. Until the full Stacks-00OE formula lands under that name (or a chosen alternative), the plan agent should either detach the pin or update it to the current conditional capstone `ringKrullDim_quotient_localization_MvPolynomial_of_regular` (private, so a pin would require making it public first).

---

## Severity summary

| Finding | Severity | Notes |
|---|---|---|
| Blueprint Step A1 recipe uses `RingTheory.isDomain_of_regularLocal` (wrong namespace; correct: `RingTheory.CohenMacaulay.isDomain_of_regularLocal`) | **must-fix-this-iter** | An iter-203 prover following the blueprint recipe will fail with unknown identifier. |
| Blueprint Step A1 recipe uses `RingTheory.regularLocal_quotient_isRegularLocal_of_notMemSq` (wrong namespace; correct: `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`) | **must-fix-this-iter** | Same reason. |
| Blueprint has no §3.B section; public declarations `isLocalization_atPrime_stalk_of_affineOpen` and `gammaSpecField_ringEquiv` lack `\lean{...}` pins | **major** | Blueprint stale w.r.t. iter-202 work; prover-facing recipe is incomplete without these pins. |
| Pin `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` has no matching Lean declaration | **major** | Pre-existing; but the plan agent should track the eventual target name and reconcile. |
| The 2 private §3.B bridges lack blueprint coverage | **minor** (acceptable) | `private` helpers; no blueprint pin required by policy. |

**Overall verdict:** The 4 new §3.B bridges are substantive, axiom-clean, and faithful to their documented purpose — no Lean-side red flags found. The blueprint has two must-fix errors: the iter-203 Step A1 recipe uses un-namespaced (wrong) names for the `RingTheory.CohenMacaulay.*` AB helpers, and the chapter is entirely silent on the 4 new iter-202 bridges, leaving the 2 public ones without `\lean{...}` pins.
