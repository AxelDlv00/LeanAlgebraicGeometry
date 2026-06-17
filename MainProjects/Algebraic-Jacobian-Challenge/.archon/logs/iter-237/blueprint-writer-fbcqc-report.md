# Blueprint Writer Report

## Slug
fbcqc

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

### Edit 1 — Fixed the circular QC dependency in `lem:pushforward_spec_tilde_iso`
- **Revised** the proof of `\label{lem:pushforward_spec_tilde_iso}`
  (`\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}`). The old sketch built the
  object iso from the Γ-level identification (`fromTildeΓ`-style, full-faithfulness
  of tilde) and then concluded quasi-coherence "from closure under iso, using the
  object iso just built" — circular, since that object iso is only an iso once the
  pushforward is *already* QC. Replaced with the non-circular route-(iii) sketch:
  - Construct the comparison morphism `α : (restr φ M)~ → (Spec φ)_* M~` as the
    tilde-adjoint of `lem:gammaPushforwardTildeIso`.
  - Reduce to checking `α` is an iso on each basic open `D(a)` via the in-file
    basis-local criterion `lem:modules_isIso_of_isBasis`
    (`isIso_of_isIso_app_of_isBasis`); basic opens form a basis.
  - On `D(a)`: source sections are `(restr φ M)[1/a]` over `R[1/a]`; target sections
    are `M[1/φa]` (since `(Spec φ)⁻¹ D(a) = D(φa)`) viewed over `R[1/a]` by
    restriction. They agree because `a` acts through `φa`, so both are the universal
    localization of `M` inverting `φa` (IsLocalizedModule compatibility). Hence `α`
    is an iso on each `D(a)`, so on the object.
  - Quasi-coherence stated **after** the object iso, as a corollary (tilde modules
    are QC, QC closed under iso). Added an explicit parenthetical warning against
    reversing the order. Added `\uses{lem:modules_isIso_of_isBasis}` to the proof.
  - The following `\begin{remark}` already states QC after the object iso, so it
    remains consistent and was left unchanged.

### Edit 2 — Added three `\lean{}` blocks for the iter-236 Γ-fragment decls
Placed in the "affine computation" subsection, immediately before
`lem:pushforward_spec_tilde_iso` (with a one-line lead-in sentence). All bespoke
project infra — no SOURCE/SOURCE QUOTE lines.
- **Added lemma** `\label{lem:globalSectionsIso_hom_comp_specMap_appTop}`
  `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` — ring-square
  naturality `gsR ∘ (Spec φ)♯_⊤ = φ ∘ gsR'`. Proof sketch: Γ⊣Spec unit naturality
  read at the top open.
- **Added lemma** `\label{lem:gammaPushforwardIso}`
  `\lean{AlgebraicGeometry.gammaPushforwardIso}` — general `N : (Spec R').Modules`,
  R-module iso `Γ((Spec φ)_* N) ≅ restr_φ (Γ N)`. Proof sketch: same underlying
  abelian group (preimage of ⊤ is ⊤); nested restrictScalars towers reconciled by
  the composition identity ×2 + the ring equation of the previous lemma. Stated
  with the general `N` form as primary, per directive. `\uses` the previous lemma.
- **Added lemma** `\label{lem:gammaPushforwardTildeIso}`
  `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` — tilde specialisation
  `Γ((Spec φ)_* M~) ≅ restr_φ M`. Proof sketch: specialise `gammaPushforwardIso` to
  `N = M~`, compose with the tilde-unit iso `Γ(M~) ≅ M`. `\uses` `gammaPushforwardIso`.

## Cross-references introduced
- `\uses{lem:modules_isIso_of_isBasis}` added in the proof of
  `lem:pushforward_spec_tilde_iso` — target exists in this same chapter (line ~112).
- `\uses{lem:globalSectionsIso_hom_comp_specMap_appTop}` in `lem:gammaPushforwardIso`
  (statement + proof) — target newly added in this chapter.
- `\uses{lem:gammaPushforwardIso}` in `lem:gammaPushforwardTildeIso` — newly added here.
- The revised `lem:pushforward_spec_tilde_iso` proof now refers to
  `lem:gammaPushforwardTildeIso` (newly added in this chapter, above it).

## References consulted
None opened this session — both edits are project-bespoke support infra explicitly
flagged by the directive as carrying no external source (SOURCE/SOURCE QUOTE omitted
by instruction). The Stacks 02KH / affine-base-change citation blocks already present
in the chapter were left untouched.

## Macros needed (if any)
None. Only standard macros (`\operatorname`, `\widetilde`, `\Gamma`) and existing
notation used.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The deep `thm:flat_base_change_pushforward` (Čech) sketch and its `% NOTE:` block
  were left untouched, per "Out of scope".
- No `\leanok`/`\mathlibok` markers added or removed (per directive + descriptor).
  The three new Γ-fragment blocks are formalized and axiom-clean per iter-236
  memory, so `sync_leanok` should mark them on its next pass.
- The lead-in paragraph before the affine-pushforward lemma now introduces the three
  Γ-fragment supports; flow reads cleanly.

## Strategy-modifying findings
None.
