The audit is complete; here are the three items requested.

## (1) Mathlib 01JJ vs AJC's `picEt`

`Scheme.LocalRepresentability.representableBy` / `.isRepresentable` — `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Sites/Representability.lean:56-58, 192, 207`.

Exact hypotheses (confirmed by `#check`):
- `F : Sheaf Scheme.zariskiTopology.{u} (Type u)` — **absolute** `Scheme.{u}`, **Zariski**, values `Type u`, bundled as a sheaf
- `{ι : Type u} {X : ι → Scheme.{u}}`, `f : (i : ι) → yoneda.obj (X i) ⟶ F.1`
- `hf : ∀ i, IsOpenImmersion.presheaf (f i)`
- `[Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]`

A **single** universe `u` ties scheme universe, index type, and value type together.

Four mismatches for `picEt C : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ Type (u+1)` (`AlgebraicJacobian/Picard/PicEtSheaf.lean:221-224`):

- **Slice vs absolute** — **(b) bridgeable, already done twice in-house.** AJC: `ZariskiDescentRepresentability.lean:315` (`gluedFunctor`) + `:1259` (`overRepresentableBy`). AJCR: `Over.sigmaExtension` (`OverSigmaExtension.lean:125`) + `Functor.RepresentableBy.overSlice` (`:235`, universe-polymorphic in `w` — the cleaner reusable bridge).
- **`Type (u+1)` vs `Type u`** — **(a) genuine obstruction.** Schemes are `Scheme.{0}`, forcing `u = 0`, so 01JJ demands `Type 0` values. `representableByUliftFunctorEquiv` (`Mathlib/CategoryTheory/Yoneda.lean:471`) only *strips* a lift; you need `picEt ≅ G ⋙ uliftFunctor` for a `Type 0`-valued `G` — an honest smallness theorem about values that are quotients of `AddCommGrpCat.{1}` carriers via `LineBundle.OnProduct`. Not free, not hours. AJCR sidestepped it by making `pic0TypeFunctor` `Type u`-valued from the start (`Pic0SigmaSheaf.lean:58`); AJC built a hand-rolled `Type 0` total functor instead. The docstring at `FGAPicRepresentability.lean:346-347` already flags this correctly.
- **Zariski vs étale** — **(b) bridgeable, free.** `zariskiTopologyOver_le_etaleTopologyOver` (`PicEtSheaf.lean:118`) + `Presieve.isSheaf_of_le` (`Mathlib/CategoryTheory/Sites/SheafOfTypes.lean:84`). Verified compiling.
- **Chart family** — **(c) new work**; this is the actual mathematics (Abel-map atlas), not plumbing.

## (2) `representable_of_openCover` is CIRCULAR over `Spec k` — proved

`ZariskiDescentRepresentability.lean:1353`. I proved the collapse in Lean, sorry-free, against the live project:

1. `Spec k` for a field is one point, so `⨆ i, U i = ⊤` forces `∃ i, U i = ⊤` (`Unique (PrimeSpectrum R)`, `Mathlib/RingTheory/Spectrum/Prime/Basic.lean:398`).
2. `(⊤ : S.Opens).ι` is an iso (`Scheme.topIso`, `Mathlib/AlgebraicGeometry/Restrict.lean:419`), hence `Over.map (⊤).ι` is an **equivalence** (`Mathlib/CategoryTheory/Comma/Over/Basic.lean:225`).
3. Transporting `RepresentableBy` across that equivalence turns `hloc i` into the conclusion verbatim.

So `hloc` **implies** the conclusion for *any* `F`, using `hF` and `hU` not at all. The engine can contribute **nothing** to this target. It is not defective — it is correct and load-bearing for `Grassmannian.representable` (`GrassmannianRepresentability.lean:598`), where the base has a real trivialising cover. Over a field the cover lattice is `{⊥, ⊤}` and it degenerates. **No `Over.map (⊤).ι` collapse lemma exists** in that file or either project; the circularity is unrecorded.

Also: `IsZariskiSheafOver (picEt C)` type-checks (I confirmed the full application elaborates at `k : Type`), but is **not derivable** from the two proved `PicEtSheaf.lean` facts — it is a bespoke `∃!`-amalgamation predicate over `T.left.Opens` covers (`:109-114`), not `Presieve.IsSheaf` of a topology. `exact?` finds nothing. No such bridge exists anywhere; the sole producer is `grassmannian_isZariskiSheafOver` (`GrassmannianZariskiSheaf.lean:1081`), proved by hand.

## (4) Cheapest true statement: étale subcanonicity on the slice

Verified sorry-free against the live project:

```lean
theorem representable_isSheaf_etaleOver {k : Type} [Field k]
    (P : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ Type 1) [P.IsRepresentable] :
    Presieve.IsSheaf (Scheme.etaleTopologyOver k) P := by
  haveI : (Scheme.etaleTopology.{0}).Subcanonical :=
    .of_le Scheme.etaleTopology_le_proetaleTopology
  exact GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable P
```

Inputs: `Scheme.etaleTopology_le_proetaleTopology` (`Mathlib/AlgebraicGeometry/Sites/Proetale.lean:77`), `proetaleTopology.Subcanonical` (`Proetale.lean:83`), `Subcanonical.of_le` (`Mathlib/CategoryTheory/Sites/Canonical.lean:155`), `subcanonical_over` (`Mathlib/CategoryTheory/Sites/SubcanonicalOver.lean:25`), `Subcanonical.isSheaf_of_isRepresentable` (`Canonical.lean:151` — **universe-polymorphic in `Type w`**, so the `Type (u+1)` wall does not bite).

Why it is the most valuable: **`Scheme.etaleTopology.Subcanonical` is nowhere instantiated in mathlib** (only zariski/fppf/fpqc/proetale have instances) though all pieces are present. And it converts the seam's central *narrative* claim into a theorem — `FGAPicRepresentability.lean:306-309` and `PicEtSheaf.lean:246-248` both argue "a representable functor is a sheaf for a subcanonical topology, hence this obligation is consistent as stated, unlike the `picSharp` version," and that argument currently has **no Lean declaration behind it**; the proved direction (`picEt_isSheaf_forget`) is the other one.

Alternatives priced: "`picEt` is a Zariski sheaf on the slice" **does not exist by name** and is two verified lines, but is nearly worthless (its only consumer is the circular engine, and it is the wrong predicate anyway). Chart-family reduction and universe descent are both blocked behind the smallness theorem — days-to-weeks, not hours.

## Dead ends, blunt

- `smoothProperQuotient` (`FGAPicRepresentability.lean:804`) **assumes its conclusion**: body is `HasSmoothProperQuotient.is_representable`, and the class field *is* `P.IsRepresentable`. `HasSmoothProperQuotient` has **zero instances** in either project. The file says it is false as stated (`:339`); believe it.
- `Scheme.QuotScheme` (`QuotRepresentability.lean:73`) is a bare `sorry` at `:79`, on a rejected route; `QuotFunctorDef.lean` carries two more (`:460`, `:715`).
- Only genuinely usable engine in AJC is `Grassmannian.representable` — sorry-free, hypotheses inhabited.

No files modified; all probes ran in `lean_run_code` scratch documents. Note `FGAPicRepresentability.lean` was edited by another lane mid-audit (959→988 lines): the `sorry` is now at **line 377**, the theorem at **369**, `smoothProperQuotient` at **804**.
