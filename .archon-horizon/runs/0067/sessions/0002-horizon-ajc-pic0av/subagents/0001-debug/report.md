Prioritised answers to your two questions. Everything below is verified first-hand by reading the cited lines.

## 1. What a k-point yields: a quotient class over a genuine invertible sheaf — but see the blocker

**Answer: (b), a quotient class with no *canonical* representative — though a representative is extractable, and the underlying type is an honest invertible sheaf.**

The chain:
- `PicScheme.representable C` — `Picard/FGAPicRepresentability.lean:576` — is a `Functor.RepresentableBy (picSharp C) (PicScheme C)`.
- `picSharp C := PicSharp.relPresheaf C ⋙ forget AddCommGrpCat` — `FGAPicRepresentability.lean:150`.
- `relPresheaf` object part — `Picard/RelPicFunctor.lean:855` — is `Quotient (relPicSetoid C.hom T.unop.hom)`.
- `relPicSetoid` — `RelPicFunctor.lean:394`, relation at `:324` — is the H_T-coset relation on `LineBundle.OnProduct C.hom πT`.
- `LineBundle.OnProduct` — `Picard/LineBundlePullback.lean:136` — is `{ M : (Limits.pullback πC πT).Modules // IsLocallyTrivial M }`, a genuine invertible sheaf on `C ×_k Spec k`.

So `homEquiv` hands you `⟦L⟧` where `L` is a real locally-trivial sheaf of modules. `Quotient.out` extracts a representative (noncomputably — fine, `degree` is already `noncomputable`; I verified `Quotient.out`/`out_eq` elaborate).

**The blocker you need most, and it is not mathematical.** `degree`'s argument is a *bare scheme morphism* `Spec (.of k) ⟶ (PicScheme C).left`, but `homEquiv` needs a morphism in `Over (Spec (.of k))`. LSP probe at `IdentityComponent.lean:1432`:

```
Application type mismatch: The argument lambda has type
  Spec (CommRingCat.of k) ⟶ (PicScheme C).left
but is expected to have type  ?m.50 ⟶ PicScheme C
```

You must supply `Over.homMk lambda h` with `h : lambda ≫ (PicScheme C).hom = 𝟙 (Spec (.of k))`, and that is **not derivable from a bare morphism**. I confirmed the `Over.homMk` route elaborates cleanly once `h` is given as `sorry`. So at its current type `degree` is only fillable by junk, and `kPoints_iff_kerDegree`'s `lambda` binder has the identical defect. Fixing the signature is cheap, is in your lane, and must precede any mathematics.

Second gap, small and worth building: at `T = Spec k` the H_T-subgroup *ought* to be trivial (one-point space ⟹ every locally trivial sheaf is trivial), collapsing the quotient to plain iso-classes and making representative-independence free. **That brick does not exist** — `IsLocallyTrivial` has only its definition (`LineBundlePullback.lean:121`) and `.pullback` (:162); no one-point/subsingleton triviality lemma anywhere in the main project.

## 2. Degree functions: no route exists

**Main project: no invertible-sheaf → ℤ and no Pic → ℤ function. mathlib: none either.** What exists:

| Declaration | file:line | sorry status | why it doesn't serve |
|---|---|---|---|
| `Scheme.WeilDivisor.degree` | `RiemannRoch/WeilDivisor.lean:973` | sorry-free | on `X.PrimeDivisor →₀ ℤ` — divisors, not sheaves |
| `Scheme.WeilDivisor.degree_hom : X.WeilDivisor →+ ℤ` | `RiemannRoch/WeilDivisor.lean:988` | sorry-free | same |
| `principal_degree_zero` | `RiemannRoch/WeilDivisor.lean:1163` | **`sorry` at :1194** (file's only one) | — |
| `DivFamily.fiberDeg` | `Picard/DivDegree.lean:195` | sorry-free (whole file is) | **ℕ-valued, effective `DivFamily` only**, not an arbitrary invertible sheaf |
| `Scheme.hilbertFunction` / `hilbertPolynomial` | `Picard/HilbertPolynomial.lean:112` / `:154` | sorry-free; `hilbertPolynomial` is *total*, junk value 0 | best substrate you have — see caveat below |

mathlib v4.31: `CommRing.Pic` (`Mathlib/RingTheory/PicardGroup.lean`) is ring-theoretic with no degree; no scheme-level divisor degree exists. Confirmed by LeanSearch and grep.

**The project already wrote this negative down.** `Picard/DivDegree.lean:104-125`: the χ-ledger `deg = χ(I) − χ(O)` (campaign P3) is unbuilt, and the adelic `WeilDivisor` degree "cannot yet be attached to the sheaf-theoretic line bundle" — that needs the `M ≅ O(div s)` regular-section bricks, also P3.

**The Rebuild has a real degree; you cannot use it.** `relPicDeg` (`Rebuild/RiemannRoch/RelPicDegree.lean:61`, `Additive (relPic C (overSpec k K)) →+ ℤ`), `PicEtAff.degAff`, `degAt` (`Rebuild/Picard/Pic0Functor.lean:54`) — all sorry-free. Two blockers:
- **No cross-import possible**: both lakefiles declare `name = "AlgebraicJacobian"`, neither requires the other.
- **The atom rests on the brick you lack**: `classDeg` (`Rebuild/RiemannRoch/Degree.lean:150`) → `classDegFun` (:111) `:= CurveDivisor.deg K (CurveDivisor.exists_picClass_eq K L).choose`, and `exists_picClass_eq` (`Rebuild/Picard/DivisorClassMeromorphic.lean:118`) is **surjectivity of `Cl(C) → Pic(C)`** via `MeromorphicPresentation` — exactly the missing P3 machinery. Its carrier `CechPic` (`Rebuild/Picard/Pic.lean:60`) is a Čech unit-cocycle quotient, a different type from `LineBundle.OnProduct`. I grepped: `CechPic`/`CurveDivisor`/`MeromorphicPresentation` appear in your project **only in prose** (`Adelic/ClassInvariance.lean:49`, `:344`).

## Brief on your other two questions

**(3) Adelic χ-route: dead, and your own lane refuted it.** `Adelic/ChiUnconditional.lean:382` `not_bump_of_notMem_left` proves `hbump` **outright false**, unconditionally, whenever a prime divisor lies off a chart of a cover with finite-dimensional chart sections; `:558` does the same for `hledger`. Since `LedgerClosure.chi_eq_of_bump` (:224) derives the ledger *from* `hbump`, that route is dead for such covers. All the RR-shaped statements take the refuted hypothesis as an **explicit caller-discharged argument** (`:286`, `:295`, `:303`, `:317`, `:331`, `:347`). Independently: the entire adelic layer is on `X.WeilDivisor`/`X.functionField`, never on sheaves — `Adelic/ClassInvariance.lean:44-55` states that nothing was ported from the sheaf-theoretic sibling. There is no `χ(L)` for a sheaf and no `L ↦ D` bridge.

**(4) `finrank_eq_genus`: bridge is missing infrastructure.** `topologicalKrullDim` has ~4 lemmas in all of mathlib (`Mathlib/Topology/KrullDimension.lean:39-69`) plus `PrimeSpectrum.topologicalKrullDim_eq_ringKrullDim` (`Mathlib/RingTheory/Spectrum/Prime/Topology.lean:1371`); **no** `Scheme.dimension`, and nothing linking it to smoothness or a tangent space. `SmoothOfRelativeDimension` (`Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:135`) is defined by local presentations with no dimension API. Nearest bridge `IsRegularLocalRing.iff_finrank_cotangentSpace` (`Mathlib/RingTheory/RegularLocalRing/Defs.lean:76`) is unusable: no "smooth over a field ⟹ regular local" instance exists anywhere (`IsRegularLocalRing` appears only in its own defs file and `KrullDimension/Regular.lean`), and no `ringKrullDim = trdeg`. Also flag: the headline wants `SmoothOfRelativeDimension (genus C)` (`Jacobian.lean:357`), not a Krull dimension — `Jacobian.lean:395-406` already maps that different route. `finrank_eq_genus` is a third formulation nobody needs; worth asking the human before spending a session.

## Recommended order

1. **Fix the `degree` signature** (over-category argument, or carry the section equation). Cheap, unblocks everything, same fix for `kPoints_iff_kerDegree`.
2. **Build one-point triviality** for `IsLocallyTrivial` in `LineBundlePullback.lean`. Small, self-contained; makes representative-independence free.
3. **Then** `degree` via `hilbertPolynomial`'s leading coefficient on `Quotient.out`.

**The honest catch on step 3, and it is the crux of your question:** the docstring's "degree-one polarisation `O_C(1)`" **cannot be written** — `Picard/ProjectiveMorphism.lean:13` records that mathlib v4.31 has no ampleness or projective-morphism vocabulary, and I found no polarisation in `Picard/`. You'd be defining degree against an *arbitrary chosen* sheaf, and the normalisation `χ(L ⊗ O(n)) = n·deg L + 1 − g` that makes the leading coefficient actually *equal* the degree is precisely the unbuilt χ-ledger.

So: after steps 1–2 you can construct a total, well-defined `→ ℤ` function, but **you cannot prove it is the degree**, and without that `kPoints_iff_kerDegree` is unreachable. The two things that would change this — the `M ≅ O(div s)` bridge (P3) and a cover where the χ-ledger holds — are both campaign-sized, and the second is currently refuted for the covers available. That is the plain negative.

Two subagents on the degree-inventory and adelic-hypothesis questions are still running; I independently verified every question I gave them against the files above, so I don't expect their reports to change this. Relevant paths: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/{IdentityComponent,FGAPicRepresentability,RelPicFunctor,LineBundlePullback,DivDegree,HilbertPolynomial}.lean` and `.../RiemannRoch/{WeilDivisor.lean,Adelic/ChiUnconditional.lean,Adelic/LedgerClosure.lean}`.
