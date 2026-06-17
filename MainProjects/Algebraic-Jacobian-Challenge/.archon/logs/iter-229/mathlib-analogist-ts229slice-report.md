# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
ts229slice

## Iteration
229

## Structural problem
A (pre)sheaf whose value at `X` is defined via the **over-category / slice** `Over X`
(`ℋom(A,B)(V) = (A|_{Over V} ⟶ B|_{Over V})`, a compatible family over all `W ≤ V`)
must be shown to **commute with restriction along an open immersion** `U ↪ X`.
Concretely close `(pushforward β).obj (dual A) ≅ dual ((pushforward β).obj A)`, where
`dual = internalHom(−, 𝟙_)` is the slice internal hom in `PresheafOfModules` over the
ringed space `(X, 𝒪_X)`. Mathlib has no MonoidalCategory / monoidal-closed structure on
`PresheafOfModules`, so the module-valued internal hom is genuinely new — but the
over-category SHAPE and the open-immersion reindexing are not.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `TopologicalSpace.Opens.overEquivalence` (`Mathlib.Topology.Sheaves.Over`) | topology / sheaves on spaces | low | ANALOGUE_FOUND |
| `CategoryTheory.Sites.Over` (`overEquiv`, `J.over`, `Sheaf.over`, `iteratedSliceEquiv` dense subsite, `overMapPullback{Id,Comp,assoc}`) | category theory / sites | medium | ANALOGUE_FOUND |
| `CategoryTheory.Sites.SheafHom` (`presheafHom`/`sheafHom`, `presheafHom_isSheafFor`) | category theory / internal hom of sheaves | low–medium | ANALOGUE_FOUND |
| `CategoryTheory.LocallyCartesianClosed.ExponentiableMorphism` | category theory / LCC, dependent product | high | PARTIAL_ANALOGUE |

## Top suggestion
**The base `Opens X` is a poset = thin category — every hom-set is a subsingleton.** The
prover's "~150–300 LOC `Over.map` pseudofunctor coherence" estimate, and every
`hom_app_heq`+`subst` fight recorded in iters 218–220, is pain inherited from mirroring
Mathlib's GENERAL-site `Sites/SheafHom.lean` + `Sites/Over.lean`, where hom-sets are
arbitrary. On `Opens X` the coherence squares (`Over.mapId`/`Over.mapComp`,
`overMapPullback_assoc`) commute automatically by `Subsingleton.elim`/`Subsingleton.helim`
(`Over.OverMorphism.ext` reduces an `Over`-hom equality to its underlying poset hom,
itself a subsingleton).

Concretely, in order:
1. Port `TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U` — already in
   Mathlib at `Mathlib/Topology/Sheaves/Over.lean` (~25 LOC). This IS the
   open-immersion slice-site reindexing equivalence the prover wanted.
2. **Read the explicit `## TODO` in that file** — it states the project's blocker
   verbatim ("show both functors of `overEquivalence U` are continuous and induce an
   equivalence `Sheaf ((Opens.grothendieckTopology X).over U) A ≌
   Sheaf (Opens.grothendieckTopology U) A`"). Fill it using the ready-made
   continuity/cocontinuity + dense-subsite instances in `Sites/Over.lean` and
   `Functor.IsDenseSubsite.sheafEquiv` (`Sites/DenseSubsite/Basic.lean`).
3. Reduce the residual `(pushforward β)(dual A) ≅ dual(pushforward β A)` to the poset
   slice identity "`Over V` in `Opens U` = `Over V` in `Opens X` for `V ≤ U`" (the
   down-set `↓V` is literally the same); the comparison functor is
   `overEquivalence`/`iteratedSliceEquiv`, naturality is `Subsingleton.elim`.

First Mathlib file to read: `Mathlib/Topology/Sheaves/Over.lean`. First project file to
touch: the file defining `Scheme.Modules.dual` / `internalHom`. Expected cost is WELL
under the 150–300 LOC general-`Over.map` estimate because thinness kills the coherence
obligations; the honest residual is the continuity-of-`overEquivalence` TODO, not a
from-scratch slice-site build.

## Discarded
- `CategoryTheory.LocallyCartesianClosed.ExponentiableMorphism` / Beck–Chevalley
  (`toOverIteratedSliceForwardIsoPullback`): correct ABSTRACT reason the comparison is
  an iso, but its internal hom is the cartesian dependent-product over the slice's
  terminal object, not the ModuleCat internal hom — value-category mismatch + heavy mate
  calculus make it not directly liftable. Kept as PARTIAL framing only.
- `Sites/CartesianClosed.lean` / `Sites/Monoidal.lean`: closed/monoidal structure on
  sheaves exists but assumes `MonoidalClosed (Cᵒᵖ ⥤ A)` and `CartesianMonoidalCategory A`
  — the cartesian (Type-like) case, not the module tensor; does not supply the
  module-valued internal hom.

## Persistent file
- `analogies/ts229slice.md` — analogue list captured for future iters.

Overall verdict: the open-immersion slice-site equivalence the prover called a 150–300
LOC blocker is largely ALREADY in Mathlib (`Opens.overEquivalence` + `Sites/Over.lean`
dense-subsite machinery), and because `Opens X` is a thin poset the dreaded `Over.map`
coherence trivialises — the genuine remaining work is the named Mathlib TODO
"`overEquivalence` is continuous ⇒ sheaf equivalence", far smaller than a from-scratch build.
