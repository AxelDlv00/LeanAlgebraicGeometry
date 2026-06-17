# Lean ↔ Blueprint Check Report

## Slug
codimone-iter179

## Iteration
179

## Files audited
- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (498 LOC)
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex` (770 LOC)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` (chapter: `def:indeterminacy_locus`)
- **Lean target exists**: yes (`CodimOneExtension.lean:145`)
- **Signature matches**: yes — `f : X.RationalMap Y → Set X` returning `(f.domain : Set X)ᶜ`, exactly the prose's "closed complement of `Dom(f)`"
- **Proof follows sketch**: N/A (definition)
- **notes**: Companion lemma `isClosed_indeterminacyLocus` (L150) is anticipated by the blueprint's "Lean encoding scope" paragraph (chapter L128–130) as an acceptable helper. Body of definition is a 1-liner exactly matching the blueprint formula `Z(f) := X ∖ Dom(f)`.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` (chapter: `def:codim_one_indeterminacy`)
- **Lean target exists**: yes (`CodimOneExtension.lean:179`)
- **Signature matches**: yes — `Prop`-valued, `∀ x : X, Order.coheight x = 1 → x ∈ f.domain`. Matches the prose's "every η ∈ X with `Order.coheight η = 1` lies in `Dom(f)`"
- **Proof follows sketch**: N/A (definition)
- **notes**: Uses the `Order.coheight` idiom pinned by `Scheme.PrimeDivisor` in `RiemannRoch/WeilDivisor.lean:92–97`, satisfying the blueprint's explicit cross-reference to `def:prime_divisor`.

### `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` (chapter: `lem:smooth_codim_one_dvr`)
- **Lean target exists**: yes (`CodimOneExtension.lean:287`)
- **Signature matches**: yes — produces `IsDiscreteValuationRing (X.left.presheaf.stalk z)` from `[Smooth X.hom] ... [IsIntegral X.left] ... (z : X.left) (_hz : Order.coheight z = 1)`. Matches the prose's typeclass set in chapter L228–232.
- **Proof follows sketch**: **partial** — the lemma's own body is structurally honest (extracts `⟨hprin, hne⟩` from the helper, exits via `IsDiscreteValuationRing.TFAE` index `(0 ↔ 4)`), but the helper `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (L222) contains one named internal `sorry` at L243 isolating the `hreg_dim` hypothesis (Smooth ⟹ `IsRegularLocalRing` at the stalk + `Order.coheight z = 1 ⟹ ringKrullDim ... = 1`).
- **notes**: The internal sorry is explicitly documented in the helper's docstring (L202–221) as packaging two Mathlib gaps (Stacks `00TT` and `02IZ`/`005X`) into a single hypothesis. The cotangent-space chain (`IsRegularLocalRing.iff_finrank_cotangentSpace` → `IsLocalRing.finrank_cotangentSpace_le_one_iff`) and the `IsField`-vs-`ringKrullDim` contradiction for `hne` are spelled out and check out structurally. Honest "iter-179 Lane D body" landing per the directive's "known issues".

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` (chapter: `thm:codim_one_extension`)
- **Lean target exists**: yes (`CodimOneExtension.lean:356`)
- **Signature matches**: yes — `∃! (g : X.left ⟶ Y.left), g.toRationalMap = f` under the typeclass set the prose pins (smooth X, complete Y, codim-1-free hypothesis)
- **Proof follows sketch**: **no** — body at L368 is bare `:= sorry`
- **notes**: Per directive, "not iter-179 targets; flag blueprint adequacy only". The file header (L33–47) and the docstring (L329–355) acknowledge the body is gated on the local-cohomology / depth-≥2 input (`cor:regular_cohen_macaulay` from `Albanese/AuslanderBuchsbaum.lean`). Blueprint chapter proof (L298–342) provides a detailed two-step sketch (codim-1 valuative-criterion ruling-out + depth-≥2 local-cohomology extension); adequate for future formalization.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` (chapter: `lem:milne_codim1_indeterminacy`)
- **Lean target exists**: yes (`CodimOneExtension.lean:397`)
- **Signature matches**: yes — the disjunction `indeterminacyLocus f = ∅ ∨ ∀ x ∈ indeterminacyLocus f, ∃ z, Order.coheight z = 1 ∧ x ∈ closure {z}` is a faithful translation of "either Z(f) is empty or every irreducible component has codim 1"
- **Proof follows sketch**: **no** — body at L411 is bare `:= sorry`
- **notes**: Per directive, "not iter-179 targets; flag blueprint adequacy only". Blueprint proof (L432–523) is the most detailed in the chapter — four explicit sub-steps formalizing Milne's difference-map argument (`Φ(x,y) := f(x)·f(y)⁻¹`, equivalence at diagonal, pullback to function field, codim-1 conclusion from pole divisors). Adequate for future formalization.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` (chapter: `thm:weil_divisor_obstruction`)
- **Lean target exists**: yes (`CodimOneExtension.lean:477`)
- **Signature matches**: **no** — see below.
- **Proof follows sketch**: **no** — see below.
- **notes**: This is the iter-179 Lane D renaming flagged in the directive's "Known issues". The blueprint pin at chapter L554 has been updated to the new name, and a `% NOTE (iter-179 review)` (chapter L557–565) documents the deferral of the substantive content. However the blueprint **theorem statement itself** (chapter L552, L579–599) — the title "Weil-divisor characterisation of the codim-1 extension obstruction" and the listed iff `(1) f defined at η_W ⇔ (2) ∀ V affine open of Y, ∀ g ∈ O_Y(V), ord_W(φ_U*(g)) ≥ 0` — is still the substantive Hartshorne–valuative content. The Lean declaration's signature is the much weaker reshuffle `W.point ∈ f.domain ↔ ∃ g : PartialMap, g.toRationalMap = f ∧ W.point ∈ g.domain`. The directive offered two options ((a) demote-blueprint vs (b) drop-`\lean{}`); **option (a) was only half-completed** (the `\lean{...}` is renamed but the prose statement is not demoted). The blueprint's chapter-level `\begin{proof}` (L602–626) still proves the substantive `ord_W ≥ 0` iff using `lem:smooth_codim_one_dvr` — not what the Lean proof actually does (a one-line `RationalMap.mem_domain` rewrite swapping the conjunction order).

## Red flags

### Placeholder / suspect bodies
- `extend_of_codimOneFree_of_smooth` at L368: body is bare `:= sorry`. Blueprint claims a substantive two-step proof. Acknowledged in the file header as iter-178+ work and explicitly flagged by the directive as "not iter-179 targets; flag blueprint adequacy only" — see Severity.
- `indeterminacy_pure_codim_one_into_grpScheme` at L411: body is bare `:= sorry`. Blueprint claims a substantive four-substep proof. Same iter-179 directive deferral as above.
- `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` at L243: one internal `sorry` for the `hreg_dim` hypothesis. **Not a hidden placeholder** — the surrounding helper body proves the principal+nonzero conclusion from `hreg_dim`, and the docstring (L202–221) names the two Mathlib bridges that supply it (Stacks `00TT`, `02IZ`/`005X`). Honest landing.

### Excuse-comments
None. The "Status (iter-177 Lane 6 file-skeleton)" header (L38–47) is a structured project-status block, not a "this is wrong but works for now" excuse. The `% NOTE (iter-179 review)` in the blueprint (L557–565) is an honest deferral marker, not an excuse-comment.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations introduced. No `Classical.choice` usage in proof bodies.

## Unreferenced declarations (informational)

- `isClosed_indeterminacyLocus` (L150) — helper closedness lemma. Acceptable: the blueprint's `def:indeterminacy_locus` Lean-encoding paragraph (L128–130) explicitly anticipates this as a standalone helper.
- `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (L222) — `private` helper for `localRing_dvr_of_codim_one`. Appropriately private; docstring documents the Mathlib gap; not promoted to the blueprint because it is internal scaffolding.

No suspicious unreferenced substantive declarations.

## Blueprint adequacy for this file

- **Coverage**: 6/6 substantive Lean declarations have a corresponding `\lean{...}` block. Unreferenced declarations: 2 helpers (`isClosed_indeterminacyLocus`, `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`) — both acceptable.
- **Proof-sketch depth**: **adequate** for `thm:codim_one_extension`, `lem:milne_codim1_indeterminacy`, and `lem:smooth_codim_one_dvr`. **Mismatched** for `thm:weil_divisor_obstruction`: the prose proof sketch (L602–626) describes how to prove the substantive `ord_W ≥ 0` iff using DVR machinery, but the proven Lean is a definitional unfold of `RationalMap.mem_domain` — the blueprint sketch over-specifies relative to the Lean target it is pinned to.
- **Hint precision**: **PRECISE** for 5 of 6 pins. **WRONG** for `thm:weil_divisor_obstruction`: the `\lean{...}` correctly names the new declaration, but the surrounding prose pins a substantive Hartshorne-valuative statement that the named declaration does not prove. A reader following the `\lean{...}` to verify the prose iff `(1) ⇔ (2 with ord_W ≥ 0)` will discover a strictly weaker proven content.
- **Generality**: **matches need** for 5 of 6. For `thm:weil_divisor_obstruction`, the blueprint is **too broad** (or symmetrically, the Lean is too narrow). The "future lemma" `extend_iff_pullback_order_nonneg` named in both the Lean docstring (L448) and the blueprint `% NOTE` (L559) is the intended substantive replacement once the `RationalMap → function-field` pullback machinery lands.
- **Recommended chapter-side actions**:
  - For `thm:weil_divisor_obstruction`, **complete option (a) or pivot to option (b)**. Option (a): demote the theorem title to "Definedness at the generic point of a prime divisor, repackaged" (or similar lighter wording), replace the iff `(1) ⇔ (2 with ord_W ≥ 0)` body with the proven mem_domain reshuffle, retain the substantive Hartshorne content as a separate `\begin{theorem}[future]{Future: pullback-order Weil-divisor obstruction}` block labelled `thm:extend_iff_pullback_order_nonneg`, and update `\uses{...}` and the `\begin{proof}` block accordingly. Option (b): detach the `\lean{...}` on L554, keep the substantive prose intact, and add a fresh weak block downstream pinning `mem_domain_iff_exists_partialMap_through_point` to its own light label (e.g. `lem:mem_domain_partial_map_reshuffle`).
  - The current half-state — renamed `\lean{...}` + retained substantive prose + explanatory `% NOTE` — leaves the bidirectional pin broken.

## Severity summary

- **must-fix-this-iter**:
  - `thm:weil_divisor_obstruction` — blueprint theorem statement (L552, L579–599) and proof (L602–626) assert the substantive Hartshorne `ord_W ≥ 0` iff, but the `\lean{...}` (L554) points to `mem_domain_iff_exists_partialMap_through_point` which proves only a `Mathlib.AlgebraicGeometry.Scheme.RationalMap.mem_domain` reshuffle. This is a signature/prose mismatch on the `\lean{...}` pin — the kind of finding the severity rule is designed to surface. The directive offered two compatible fixes (option (a) demote prose, option (b) detach `\lean{...}`); neither is complete. Plan agent should dispatch the blueprint-writing subagent.
- **major**:
  - `extend_of_codimOneFree_of_smooth` (L368) and `indeterminacy_pure_codim_one_into_grpScheme` (L411): both bare `:= sorry` on declarations whose blueprint claims a substantive proof. Per directive these are "not iter-179 targets; flag blueprint adequacy only". Blueprint adequacy itself is good: both chapter proofs provide step-by-step sketches a future prover can follow. Major (not must-fix) because the chapter file-status (L38–47) honestly flags them as iter-178+ skeleton placeholders gated on `cor:regular_cohen_macaulay` and downstream Mathlib local-cohomology gaps — the gating fact is documented, not hidden.
- **minor**:
  - The internal `sorry` in `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (L243) for `hreg_dim`. Honest landing: the helper docstring names the two precise Mathlib bridges that close it, and the surrounding helper body proves the public-facing principal+nonzero conclusion from `hreg_dim`. Worth tracking but not a placeholder under the severity rule.
  - The blueprint's Lean-encoding bullet list (L678–681) still references the old name `extend_iff_order_nonneg` for the Weil-divisor obstruction theorem. Cosmetic stale reference; should be updated when option (a)/(b) is completed.

**Overall verdict**: The five non-Weil pins (`def:indeterminacy_locus`, `def:codim_one_indeterminacy`, `lem:smooth_codim_one_dvr`, `thm:codim_one_extension`, `lem:milne_codim1_indeterminacy`) are bidirectionally clean modulo the acknowledged iter-178+ file-skeleton sorries; the `thm:weil_divisor_obstruction` pin is in a half-completed renaming state where the `\lean{...}` was updated but the prose statement was not demoted, leaving the blueprint asserting strictly more than the Lean proves — must-fix this iter via either option (a) or option (b).
