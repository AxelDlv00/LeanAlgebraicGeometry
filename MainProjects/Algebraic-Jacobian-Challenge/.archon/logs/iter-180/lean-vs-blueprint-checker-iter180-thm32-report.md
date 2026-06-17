# Lean ↔ Blueprint Check Report

## Slug
iter180-thm32

## Iteration
180

## Files audited
- Lean: `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`
- Blueprint: `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`

## Per-declaration

The chapter pins exactly one Lean target.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` (chapter: `thm:rational_map_to_av_extends`, blueprint L52)

- **Lean target exists**: yes — `theorem extend_to_av` at L320 of the Lean file, in namespace `AlgebraicGeometry.Scheme.RationalMap`. Fully-qualified name matches the pin verbatim.
- **Signature matches**: yes. The blueprint prose (L61–66, L186–191) requires "for X a nonsingular variety over k̄ and A an abelian variety over k̄, every rational map f : X ⇢ A admits a unique regular extension g : X → A with g.toRationalMap = f". The Lean signature encodes:
  - `X : Over (Spec (.of kbar))` with `[Smooth X.hom] [GeometricallyIrreducible X.hom] [IsSeparated X.hom] [LocallyOfFiniteType X.hom] [IsIntegral X.left] [IsReduced X.left]` — matches the project's "nonsingular variety over k̄" convention enumerated in the file docstring L74–82 and used throughout `AbelianVarietyRigidity.lean` / `Jacobian.lean`.
  - `A : Over (Spec (.of kbar))` with `[GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]` — matches the project's abelian-variety four-instance convention (file docstring L66–71).
  - `f : X.left.RationalMap A.left` and conclusion `∃! g, g.toRationalMap = f`. This is precisely the substantive existence-and-uniqueness claim from the blueprint.
- **Proof follows sketch**: partial. The Lean proof body inlines the blueprint's three-step argument:
  - Step 1 (extension from `CodimOneFree`): delegates to `extend_of_codimOneFree_of_smooth` (Milne 3.1, sibling file `Albanese/CodimOneExtension.lean`) — matches blueprint L89–91.
  - Step 2 (`CodimOneFree f` discharge from Milne 3.1 ∩ Lemma 3.3): delegates to the private helper `av_isIntegral_and_codimOneFree`, which routes through `av_codimOneFree_of_indeterminacy`. The helper body is a bare `sorry` (L252) but the docstring (L197–232) documents the exact two-line combination strategy verbatim against blueprint L88–97.
  - Step 3 (variety-package instance materialization on `A.left`): inline `haveI`s at L332–336 — not in the blueprint prose but routine instance discharge.
  The `extend_to_av` body itself has no inline `sorry`. The blueprint's sketch is faithfully formalized as a *delegation pattern* to two helpers, one of which (`av_codimOneFree_of_indeterminacy`) is a documented sorry. The mathematical content of the blueprint proof is therefore present in the file but not closed.
- **notes**: The blueprint's `\leanok` marker on the statement (L49) and proof block (L78) overstates the current state — the proof is *structurally* assembled but transitively reaches 1 sorry inside `av_codimOneFree_of_indeterminacy`, 1 sorry inside `av_isIntegral_of_smooth_geomIrred` (for `IsReduced A.left`), and 1 sorry in the sibling `extend_of_codimOneFree_of_smooth`. The `sync_leanok` deterministic phase should reconcile this.

## Red flags

### Placeholder / suspect bodies

- `av_isIntegral_of_smooth_geomIrred` at L176–195: contains `haveI : IsReduced A.left := sorry` at L194. The docstring (L162–170) identifies the precise Mathlib gap (Stacks `034V`/`02G4`: `Smooth A.hom → IsReduced A.left` not exposed at the project's pinned commit). This is a localized, well-named sorry on a private helper; not blueprint-pinned.
- `av_codimOneFree_of_indeterminacy` at L233–252: body is `sorry` at L252. The docstring (L197–232) lays out the exact two-input combination strategy (Lemma 3.3 disjunction + codim-≥2 conclusion of Milne 3.1) and identifies the precise reason the proof cannot close axiom-clean today: the codim-≥2 conclusion of Milne 3.1 is currently bundled *inside* `extend_of_codimOneFree_of_smooth`'s (also-sorry) body in `Albanese/CodimOneExtension.lean`, not exposed as a standalone lemma. Private helper; not blueprint-pinned.

These two helpers carry the project's iter-180 status accurately. They are NOT laundering excuses — both docstrings identify the precise project-side / Mathlib-side gap that prevents closure and name the work needed to discharge them. The blueprint pin `extend_to_av` itself has no inline placeholder; it relies on the helpers and the sibling-file `extend_of_codimOneFree_of_smooth` (itself sorry at iter-180).

### Excuse-comments
None. All in-body comments are honest strategy notes (L182–193, L244–251) that name the exact missing piece rather than excusing wrong code.

### Axioms / Classical.choice on non-trivial claims
None.

## Unreferenced declarations (informational)

Three private helpers, all introduced this iter as part of the Lane G split. None are individually blueprint-pinned, which is correct — they are internal scaffolding for `extend_to_av`'s proof and the blueprint should not reference them.

- `av_isIntegral_of_smooth_geomIrred` (L176) — packages `IsIntegral A.left` derivation. Three-step reasoning (singleton base + GeometricallyIrreducible + IsReduced). Private; helper-only role appropriate.
- `av_codimOneFree_of_indeterminacy` (L233) — packages `CodimOneFree f` derivation. Private; helper-only role appropriate.
- `av_isIntegral_and_codimOneFree` (L267) — axiom-clean wrapper preserving the iter-179 call-site shape. Private; routing-only role appropriate.

## Blueprint adequacy for this file

- **Coverage**: 1/4 Lean declarations have a corresponding `\lean{...}` block — the one pinned declaration is the file's externally-consumed export; the three unpinned ones are private helpers. Coverage is appropriate.
- **Proof-sketch depth**: **adequate**. The blueprint's three-step proof at L88–97 enumerates exactly the steps the prover formalized as the helper chain. The enumeration "(1) Milne 3.1 ⟹ codim ≥ 2, (2) Lemma 3.3 ⟹ empty or pure codim 1, (3) both ⟹ Z = ∅" matches the prover's reasoning verbatim. The blueprint correctly signals that BOTH inputs are needed, which is precisely the prover's rationale for not closing `av_codimOneFree_of_indeterminacy` from Lemma 3.3 alone (the directive author's framing on that point was incorrect; the chapter prose vindicates the prover).
- **Hint precision**: **precise**. The `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` pin names the declaration unambiguously and matches the Lean signature. The chapter's L184–191 informal signature spec further constrains the type to `∃! g : X → A, g extends f`, which the Lean theorem encodes exactly.
- **Generality**: **matches need**. The chapter encodes the convention used throughout the project (over algebraically closed `kbar`, with the "abelian variety = four instances on `Over (Spec ...)`" convention from `AbelianVarietyRigidity.lean`).
- **Recommended chapter-side actions**: None substantive. Two optional polish items the blueprint-writer could consider (NOT must-fix, NOT blocking):
  1. The "Lean encoding" section (L178–211) could note that the codim-≥2 conclusion of Milne 3.1 is currently *inside* `extend_of_codimOneFree_of_smooth`'s body in `Albanese/CodimOneExtension.lean`, not standalone, and that the natural Lean-side refactor is to expose it as a separate lemma (e.g. `indeterminacy_codimGe2_of_smooth_of_complete`). This would let the prover close `av_codimOneFree_of_indeterminacy` axiom-clean.
  2. The chapter does not mention the project-side "Mathlib gap" that `Smooth A.hom ⟹ IsReduced A.left` is not exposed (Stacks `034V`/`02G4` direction over a field). The prover's helper `av_isIntegral_of_smooth_geomIrred` had to carry this as a sorry. A `% NOTE:` comment in `\section{Lean encoding}` flagging this would be honest about the formalization friction. Again, not a blueprint defect — pure-math prose can fairly leave such automatic implications implicit.

## Severity summary

- **must-fix-this-iter**: none.
  - The pinned declaration `extend_to_av` has no direct placeholder body. Its proof transitively reaches sorries inside two private helpers and the sibling `extend_of_codimOneFree_of_smooth`, but each transitive sorry is documented and named, and the directive *explicitly sanctioned* the iter-180 split (1 sorry → 2 narrower sorries). The "Placeholder body on a substantive declaration" must-fix rule applies to *direct* placeholders, and the pinned declaration has none.
  - No signature mismatch — the Lean encodes the blueprint statement precisely.
  - No excuse-comments — helper docstrings are honest gap-naming, not laundering.
  - No unauthorized axioms.
  - Blueprint adequacy: adequate (proof sketch matches the helper structure, hint is precise, generality matches need).
- **major**:
  - The pin `\leanok` markers in the blueprint (L49 statement block, L78 proof block) overstate iter-180 reality — the proof transitively reaches sorries. This is owned by `sync_leanok`, not the prover; flagged here only so the planner is aware that the chapter currently looks "done" in the dashboard.
  - The chapter's `\section{Lean encoding}` does not mention that the codim-≥2 conclusion of Milne 3.1 needs to be exposed as a standalone Lean lemma to close `av_codimOneFree_of_indeterminacy`. This is the most actionable blueprint expansion if the planner wants the prover to retire that helper sorry next iter.
- **minor**:
  - The chapter does not explicitly document that `Smooth ⟹ IsReduced` is a Mathlib-gap formalization friction; the prover hit this in `av_isIntegral_of_smooth_geomIrred`. A `% NOTE:` would close the loop.

**Overall verdict**: The Lean file faithfully implements the blueprint's three-step proof skeleton with substantive content correctly concentrated in two named private helpers; the directive's "Lemma 3.3 as black box closes it" framing was incorrect, the blueprint and the prover both agree that BOTH Milne 3.1 codim-≥2 AND Lemma 3.3 are needed, and the file's current 2-sorry state is the correct iter-180 deliverable per the directive's Option (a) split. No must-fix findings; chapter expansion to surface the missing project-side lemma (codim-≥2 standalone) would unblock iter-181+.
