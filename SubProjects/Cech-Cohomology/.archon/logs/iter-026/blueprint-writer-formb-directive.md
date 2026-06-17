# Directive: rewrite the absolute-cohomology realization to Form B (corepresenting object) in `Cohomology_CechHigherDirectImage.tex`

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — ONLY this chapter.

## Strategy context (the slice that matters)

The project realizes absolute sheaf cohomology `H^p(U,F)` of an `O_X`-module over an open `U ⊆ X` so
that the Stacks-01EO dimension shift has H⁰=Γ, injective vanishing, and a covariant long exact sequence
off-the-shelf. The realization is **Ext of a corepresenting object**, decided iter-026 after a
mathlib-analogist investigation (`analogies/restriction-preserves-injectives.md`):

```
H^p(U, F) := Ext^p_{X.Modules}(jShriekOU U, F),      jShriekOU U := sheafification(free(yoneda U)).
```

`jShriekOU U` is the object of `X.Modules` corepresenting the global-sections-over-`U` functor
`F ↦ Γ(U,F) = F(U)`; it is `j_!O_U` (extension-by-zero of the structure sheaf of `U`) up to iso, but
crucially we build only the OBJECT, not the `j_!` functor. It is composed from pieces the project
already ships:
- `freeYonedaHomEquiv` (`PresheafCech.lean:245`): `Hom_{PMod}(free(yoneda U), F) ≃ F(U)`, additive
  upgrade `freeYonedaHomAddEquiv`.
- `PresheafOfModules.sheafificationAdjunction`: transports corepresentability through sheafification,
  `Hom_{X.Modules}(sheafify(P), F) ≅ Hom_{PMod}(P, forget F)`.
Composite: `Hom_{X.Modules}(jShriekOU U, F) ≅ Hom_{PMod}(free(yoneda U), forget F) ≅ F(U) = Γ(U,F)`.

**Why Form B over the previous Form A** (`Ext^p_{Mod(O_U)}(O_U, F|_U)`, which the chapter currently
states as the primary realization): under Form A the 01EO injective-vanishing step `H^n(U,I)=0` needs
`I|_U` injective in `Mod(O_U)` (restriction-preserves-injectives), which has no Mathlib route short of
building the `j_!` functor (200–500 LOC; `j_!` is verified absent — loogle `_ ⊣ restrictFunctor _` is
empty). Under Form B the SES `0→F→I→Q→0` stays in `X.Modules`, the injective `I` sits in the SECOND Ext
argument where Mathlib's `Ext.eq_zero_of_injective` applies directly, and restriction is never taken.
Form B is ~50–80 LOC of reuse and needs NO restriction-preserves-injectives. The chapter must be
rewritten to make Form B the primary (and only) realization.

## Required edits

### 1. Add the covered file
At the chapter top (the `% archon:covers` block), add:
```
% archon:covers AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean
```
The absolute-cohomology declarations will live in a new file `AbsoluteCohomology.lean`.

### 2. New block: the corepresenting object `jShriekOU` and its corepresentability
Add a definition block + a lemma block (project-original — NO external source, so no `% SOURCE`/
`% SOURCE QUOTE` lines; the realization is a design choice, the math is standard corepresentability):
- `\begin{definition}[Extension-by-zero structure sheaf as a corepresenting object]` `\label{def:jshriek_ou}`
  `\lean{AlgebraicGeometry.jShriekOU}` — `jShriekOU U := sheafification(free(yoneda U))` in `X.Modules`;
  note it equals `j_!O_U` up to iso but is built as the sheafification of the free module on the
  representable presheaf `yoneda U`, with no extension-by-zero functor.
  `\uses{}` the Mathlib anchors for `free`, `sheafificationAdjunction`, and the project's
  `freeYonedaHomEquiv` (give that a `\lean{}`-pinned anchor block if one does not already exist — check
  whether `freeYonedaHomEquiv`/`freeYonedaHomAddEquiv` are already blueprinted in this chapter and
  `\uses` the existing label; if not, add a one-line anchor block for them).
- `\begin{lemma}[Corepresentability of global sections over U]` `\label{lem:jshriek_corepr}`
  `\lean{AlgebraicGeometry.jShriekOU_homEquiv}` — natural additive iso
  `Hom_{X.Modules}(jShriekOU U, F) ≅ Γ(U,F) = F(U)`, with a one-line proof: compose
  `sheafificationAdjunction.homEquiv` with `freeYonedaHomAddEquiv U F`. `\uses{def:jshriek_ou}` + the
  two adjunction anchors.

### 3. Rewrite `def:absolute_cohomology` to Form B
Make the primary definition `H^p(U,F) := Ext^p_{X.Modules}(jShriekOU U, F)`. Drop the "Form A primary /
Form B equivalently" hedge. The three structural clauses now read:
- **Degree zero = global sections**: `Ext^0(jShriekOU U, F) ≅ Hom(jShriekOU U, F) ≅ Γ(U,F)` via
  `Ext.homEquiv₀` (`lem:ext_homequiv_zero_mathlib`) then `lem:jshriek_corepr` (the corepresentability
  iso) — NOT via `O_U`/`unitHomEquiv` anymore.
- **Injective vanishing**: for an injective `O_X`-module `I` placed in the SECOND argument,
  `Ext^{n+1}(jShriekOU U, I) = 0` by `lem:ext_eq_zero_of_injective_mathlib`, directly, the SES staying
  in `X.Modules` — explicitly state "no restriction is taken and restriction-preserves-injectives is
  not needed."
- **Long exact sequence**: for a SES `0→F→I→Q→0` in `X.Modules` and fixed first argument `jShriekOU U`,
  the covariant Ext LES (`lem:ext_covariant_les_mathlib`).
Update `def:absolute_cohomology`'s `\uses{}` to include `def:jshriek_ou`, `lem:jshriek_corepr` and the
existing Ext anchors; pin `\lean{AlgebraicGeometry.absoluteCohomology}` (the `H^p(U,-)` functor/def in
the new file — the prover will name it `absoluteCohomology`; if you prefer a different Lean name, pick
ONE and use it consistently across all `\lean{}` pins in this chapter).
Keep the `lem:modules_restrict_functor_mathlib` anchor only if still referenced; if Form B no longer
uses `restrictFunctor` anywhere in the chapter, drop that anchor block (and any `\uses` of it) to keep
the dependency graph honest — verify by grepping the chapter for `restrictFunctor`/`restrict`/`F|_U`.

### 4. Update the 01EO proof (`lem:cech_to_cohomology_on_basis`, the proof at ~lines 3109–3174)
Where it invokes injective vanishing "`H^n(U,I)=0` ... I placed in the second Ext argument": adjust the
prose to Form B — the SES `0→F→I→Q→0` is in `X.Modules`, `H^n(U,-) = Ext^n(jShriekOU U, -)` is covariant
in the second variable with fixed first arg `jShriekOU U`, the injective `I` is the second argument so
`H^n(U,I)=0` is immediate from `lem:ext_eq_zero_of_injective_mathlib`, and `H^0(U,-)=Γ(U,-)` is
`lem:jshriek_corepr`∘`Ext.homEquiv₀`. Keep the existing Stacks `% SOURCE QUOTE`/`% SOURCE QUOTE PROOF`
verbatim comments intact (they are the citation for the math). Only the realization-specific prose changes.

### 5. Consistency sweep
Grep the chapter for any remaining `Ext^p_{Mod(O_U)}`, `O_U`, `F|_U`, `restriction preserves
injectives`, or "Form A"/"Form B" wording in the absolute-cohomology section and the 02KG
`affine_serre_vanishing` block; reconcile all of it to the single Form B realization. `lem:affine_serre_vanishing`
and its proof reference `def:absolute_cohomology` — keep those `\uses` but make sure the prose says
"the Ext realization of Def~\ref{def:absolute_cohomology}" without Form-A language.

## Hard constraints
- Edit ONLY `Cohomology_CechHigherDirectImage.tex`.
- Do NOT add or touch `\leanok` anywhere (managed by the deterministic sync). You MAY keep/place
  `\mathlibok` ONLY on the genuine Mathlib anchor blocks (`lem:ext_*_mathlib`, `lem:hasext_standard_mathlib`)
  — never on the project's own `def:jshriek_ou` / `lem:jshriek_corepr` / `def:absolute_cohomology`.
- Citation discipline: the corepresentability/realization blocks are project-original (no `% SOURCE`).
  The 01EO/02KG blocks keep their existing verbatim Stacks quotes — do not delete or alter them.
- Keep every block's `\uses{}` accurate to what the math actually needs (this feeds the dependency graph).

## Report
List the blocks added/edited, the final `\lean{}` names you pinned (so the prover scaffolds matching
declarations), and any block whose `\uses` you changed. Flag any place you were unsure whether a
Mathlib anchor exists.
