# mathlib-analogist directive — FBC adjoint-mate leg-lock (iter-020)

## Mode: cross-domain-inspiration

## Structural problem

We are computing an **adjoint-mate / base-change map** between sheaves of modules. Concretely, for a
pullback square of schemes with legs `f, g, f', g'`, the canonical natural transformation
`g^* f_* F ⟶ f'_* g'^* F` (the mate of the base-change 2-cell under the `(pullback ⊣ pushforward)`
adjunctions) must be shown to equal a known explicit comparison map after taking global sections
`Γ`. The crux sub-step ("Seam 2 / fstar-reindex") is a purely formal coherence: it expands the
adjunction **unit** on a *composite* morphism `g' = a ≫ b` via the standard
"unit-of-composite-adjunction" identity
`η^{a≫b} = η^b ≫ b_*(η^a) ≫ pushforwardComp(a,b).hom ≫ (a≫b)_*(pullbackComp(a,b).hom)`,
distributes a functor `(Spec φ)_* ⋙ Γ` over the four factors, then cancels the `pullbackComp` /
`pushforwardComp` coherence isos against a "codomain-read" dictionary to land on the target value.

The abstract shape: **a telescoping cancellation of associator/unitor/comparison-iso coherence cells
in a composite-of-adjunctions calculation** (Beck–Chevalley / mate calculus), carried out inside one
big proof term.

## Failed approaches

- **Tactic-mode `rw` of the unit-expansion into the assembly goal** (iters 014–019): the assembly
  lemma quantifies over free legs `g', f'` with hypotheses `hfst : g' = …`, `hsnd : f' = …`, then
  `subst`s them. After `subst`, the leg becomes a *locked literal* `(pullbackSpecIso …).hom ≫
  Spec.map (CommRingCat.ofHom …)`, and `rw [unitExpand]` cannot unify the metavariable composite
  pattern `?a ≫ ?b` against this locked `≫` — the rewrite never matches. 6 iters unmoved.
- **Pervasive `X.Modules` instance diamond**: even when a rewrite *should* match (`Category.assoc`,
  `Functor.map_comp`, `Iso.inv_hom_id_app`), tactic-mode `rw`/`simp` fail to fire because the
  category-of-modules-on-a-scheme instance is presented two defeq-but-not-syntactically-equal ways.
  Worked around in **term mode** (`congrArg`, `.trans`, associativity/`map_comp` as terms) for the
  two sub-lemmas that ARE stateable standalone (`_unitExpand`, `_gammaDistribute`).
- **Effort-break into standalone atomic lemmas** (iter-019): 2 of 5 links closed (term mode); the
  remaining 3 (`_eCancel`, `_affineUnit`, `_innerMatch`) **cannot be stated standalone** — their
  types only materialize from the mid-assembly goal state, which the leg-lock prevents reaching.

## Search radius: wide

## What I'm looking for

Concrete Mathlib precedents (with declaration names / file paths) where a **mate / Beck–Chevalley /
base-change-map coherence is computed or proven**, especially any that:
1. compute the mate of a composite morphism / a composite of adjunctions WITHOUT `subst`-ing the
   legs into locked literals — e.g. keeping the morphism abstract and using `Adjunction.comp`,
   `mateEquiv`, `conjugateEquiv`, `Functor.associator`/`leftUnitor` coherence lemmas, or
   `whiskerLeft`/`whiskerRight` calculus;
2. telescope associator/comparison-iso cancellations in term mode or via a dedicated
   `@[reassoc]`/`Category.assoc`-driven simp set rather than positional `rw`;
3. survive an instance-diamond on the ambient category by working in a `CategoryTheory`-generic
   setting and only specializing at the very end.

For each precedent: the Mathlib citation, the technique used there, and a concrete suggestion for how
to port it to restructure `base_change_mate_fstar_reindex_legs` so the unit-expansion is applied
while the leg is still a *free local* (before `subst`), making the cancellation reachable. This is an
exploration list to guide an iter-021 refactor — not a directive.
