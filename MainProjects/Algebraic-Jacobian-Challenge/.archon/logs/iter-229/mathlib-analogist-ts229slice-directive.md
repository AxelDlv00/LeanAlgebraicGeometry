# mathlib-analogist directive — ts229slice

## Mode: cross-domain-inspiration

## Structural problem

We need to prove, for an **open immersion** of schemes (equivalently, an open
subset inclusion of ringed spaces) `f : U ↪ X`, that **restriction to the open
commutes with the internal-hom / dual of sheaves of modules**:

```
(restrict_f)(ℋom_X(A, B))  ≅  ℋom_U( (restrict_f) A , (restrict_f) B )
```

specialised to the dual `B = 𝒪` (so `ℋom(A,𝒪) = dual A`). Concretely the residual
that must be closed is

```
(pushforward β).obj (dual A)  ≅  dual ((pushforward β).obj A)
```

where `dual = internalHom(-, 𝟙_)` is the **slice / over-category internal hom** in
`PresheafOfModules` over the ringed space `(X, 𝒪_X)`: its value at an open `V` is the
**morphism module** `(restr_V A ⟶ restr_V 𝟙_)` — a compatible family over the slice
category `Over V` (all `W ≤ V`), NOT a sectionwise `restrictScalars`-image.

Mathlib has **no** `MonoidalCategory`, **no** `internalHom`, and **no** monoidal-closed
structure on `PresheafOfModules` / `SheafOfModules` (confirmed by `loogle`), so this is
genuinely new infrastructure. The project's prover diagnosed the missing piece precisely:
an **equivalence of slice sites induced by the open immersion** — for `V ∈ Opens X`
contained in `U`, the over-category `Over V` taken in `Opens U` is equivalent to
`Over V` taken in `Opens X`, and this equivalence transports the morphism modules
`(restr A ⟶ restr 𝟙_)` naturally and compatibly with `restrict` / `pushforward`. The
prover estimates ~150–300 LOC (`Over.map` / equivalence pseudofunctor coherence).

We want to know: **how has Mathlib solved the SAME structural shape — "a presheaf/sheaf
defined via an over-category (slice) value commutes with restriction along an open
immersion (or more generally pullback along a morphism of sites)" — in some other domain**,
so we can port the cleanest technique and minimise the bespoke LOC.

Questions to answer concretely:
1. Does Mathlib have a reusable **slice-site / over-category reindexing equivalence**
   for an open immersion or a continuous map of spaces (e.g. `Opens.map`, `Over.map`,
   `CategoryTheory.Comma`/`StructuredArrow` reindexing, `TopCat.Presheaf` /
   `TopCat.Sheaf` restriction-along-open machinery) that already proves "an over-category-
   valued construction commutes with restriction"?
2. Does Mathlib's **`CategoryTheory.Sites`** layer (Grothendieck-topology pullback /
   `Sites.Pullback`, `Functor.sheafPushforwardContinuous`, cover-lifting, the
   `OverCategory`/localization-at-an-object equivalences) give "restriction commutes with
   internal hom" for sheaves on a site, which we could specialise to `Opens U ↪ Opens X`?
3. Is there a precedent for **internal-hom / exponential objects commuting with a
   geometric-morphism inverse image** (topos theory, sheaves on a site, condensed/light
   sheaves, étale sheaves) that we can mirror? For an OPEN immersion the inverse image is
   exact and the comparison should be an iso — has anyone formalised that shape?

## Failed approaches

- **Verbatim mirror of the closed sectionwise tensor restrict-iso** (`tensorObj_restrict_iso`):
  the tensor's strong-monoidal `restrictScalars` tensorator route works because the tensor
  is **sectionwise** `M(V) ⊗_{R(V)} N(V)` — a literal `restrictScalars`-image. The dual /
  slice internal-hom is NOT sectionwise, so `restrictScalarsRingIsoDualEquiv` (the ModuleCat
  shadow) cannot be lifted. Steps 1–3 + the open-immersion-pushforward step H1 of the mirror
  typecheck; the residual H2′ does NOT close. (Empirically confirmed via `lean_goal`, iter-228.)
- **Abandoned d.2 stalk-⊗ route** (varying-ring stalk tensor): retired many iters ago as a
  ~300–500 LOC dead end; the slice reindexing is structural, not a stalk, so it does NOT
  re-introduce d.2 — but we still lack the construction.

## Search radius: narrow

(same general area — sheaf theory / sites / over-categories / topos inverse image — but a
different sub-area than sheaves-of-modules-on-schemes is welcome.)

## Deliverable

A ranked list of structural analogues, each with: the Mathlib citation (declaration name +
file), the technique used there, and a concrete suggestion for how to port it to the
open-immersion slice-internal-hom-commutes-with-restriction problem. If the honest answer is
"no Mathlib analogue exists; the ~150–300 LOC bespoke `Over.map` build is unavoidable", say
so plainly — that is itself a high-value verdict that confirms the cost.
