Measured everything at the current worktree state (full `lake build` of the target module completed: 8692 jobs, only `QuotFunctorDef:458/:690` and `FGAPicRepresentability:803` reporting `declaration uses 'sorry'`). All axiom claims below are `#print axioms` results I ran, not recollection.

## (A) Producers of `RepresentableBy` for `picEt` / `picSharp`: **none**

Every declaration in AJC whose conclusion is (or contains) `Functor.RepresentableBy (picEt _) _` or `(picSharp _) _`, with its verdict:

| site | verdict |
|---|---|
| `Picard/FGAPicRepresentability.lean:803` `fgaPicardRepresentability` | **the `sorry`** (body at `:811`). `[propext, sorryAx, Classical.choice, Quot.sound]` |
| `…:831` `HasPicSchemeEt` (class field), `:842` `instHasPicSchemeEt` | the instance is `⟨(fgaPicardRepresentability C).1⟩` — a projection of the `sorry`. Measured `sorryAx` |
| `…:900` `representableEt` | extraction from the `[HasPicSchemeEt C]` binder. Clean *as an implication*; at a use site with only the three geometric binders it fires `sorryAx` — I reproduced this in a scratch probe (`useSiteRep`, `useSiteExists`: both `sorryAx`), because `instHasPicSchemeEt` is unconditional |
| `…:1431/:1438` `PicSharpRepresentable` + `instPicSharpRepresentable` | `choose_spec.1` of its own `[HasPicScheme C]` hypothesis; `P → P` |
| `…:1459` `representable` | from `[PicSharpRepresentable C]` |
| `…:1060` `picSchemeOfHasRationalPoint` | real theorem, but built from both clauses of the seam `sorry` + `[HasRationalPoint C]`. Measured `sorryAx` |
| `Picard/PicEtSubcanonical.lean:321` `picSharp_representableBy_picEt_transport`, `:344` `hasPicSchemeEt_of_picSharp_representability` | **transport**: takes `rep`/the `picSharp` existential. Both axiom-clean, both consume representability |
| `Picard/PicEtSeparated.lean:250`/`:260` `picEtClauseOne_of_picSharp_representableBy_locallyOfFiniteType` | transport of an assumed existential; clean |
| `Picard/PicEtDescentAssembly.lean:236` `representableByRestrict_of_baseChange` | takes `rep` over `k'`; restates it in the right variables (its own file says it does not cross the descent step) |
| `Picard/GaloisDescent/PicEtGaloisAction.lean:604` `representableByTwist` | takes `rep`, produces a second representation of the same functor by the twisted object; clean |
| `Picard/Pic0DualNumberCocycle.lean:366/:433` | generic in an arbitrary `F`/`G`; takes `rep` |
| `Picard/PicEtSubcanonical.lean:490/:506` | *negative*: `IsEmpty (…RepresentableBy X)` / `¬∃ X, …`, conditional on `¬ IsIso (picEtComparison C)` |

**One candidate that takes neither a `rep` nor a gate class** — worth naming precisely because it is the only one:

- `Picard/PicEtDescentRepresentability.lean:341` `representableBy_of_coverCompatibleEquiv` and `:456` `representableBy_of_galInvariantEquiv`. Hypotheses are a per-test `Equiv` family `(T ⟶ Y) ≃ CoverCompatible C T` (+ naturality; + `hcov` at every test in the Γ-invariant form). Both axiom-clean. But `:376` `coverCompatibleEquiv_of_representableBy` is the **converse**, also proved, so this is a change of coordinates, not a producer: to represent `picEt C` it is *equivalent* to represent the cover-compatible-classes functor. `Y` and the `Equiv` family are hypotheses; nothing in the tree instantiates them at any curve (only internal use is `:469`).

So: **zero producers at any curve over any field.** Consumer-side census (declaration headers binding `[HasPicScheme]`, `[HasPicSchemeEt]`, `[PicSharpRepresentable]`, or a `(rep : … RepresentableBy …)`): **102**, concentrated in `Pic0AbelianVariety.lean` (34), `FGAPicRepresentability.lean` (14), `IdentityComponent.lean` (14), `Pic0EtTangentSpace.lean` (12), `Pic0Et.lean` (10). The "93" figure in your brief is the same order; I could not reproduce 93 exactly with any single scoping I tried, so treat 102 as method-dependent, not as a correction.

## (B) Functors that *do* have genuine `RepresentableBy` producers

All four below I probed with `#print axioms`; all are `[propext, Classical.choice, Quot.sound]`.

1. `AlgebraicGeometry.Grassmannian.represents` — `Picard/GrassmannianQuot.lean:5608`. Sorry-free, clean. Mechanism: **explicit chart construction + glued-scheme universal property** — forward map pulls back the tautological rank quotient, inverse is `grPointOfRankQuotient` built chart-by-chart and glued.
2. `Scheme.Grassmannian.prodRepresentableBy` — `Picard/GrassmannianRepresentability.lean:357`. Clean. Mechanism: **adjunction/terminal-object argument** — `Over.forget S ⊣ Over.star S` transports absolute representability into `Over S` (this is the "representable by base change of the absolute object" route). Feeds `representable_of_iso_free:380` → `representable_restrict:559` → `representable:595` (`∃ Y, Nonempty ((Grassmannian V d).RepresentableBy Y)` for locally free `V`), all clean.
3. `Scheme.representable_of_openCover` — `Picard/ZariskiDescentRepresentability.lean:1353`, with the core at `:1259` `ZariskiDescent.overRepresentableBy`. Sorry-free (the whole file's project-import closure is 1 module), clean. Mechanism: **Zariski descent / open cover of the base** — a `Type 0` total-functor encoding fed to mathlib's `Scheme.LocalRepresentability.representableBy` (Stacks 01JJ), then transported back to `Over S`.
4. `GroupScheme.IdentityComponent.isSubgroupHomomorphism` — `Picard/IdentityComponent.lean:737`, via the private `identityComponentRepresentableBy:707`. Clean (despite two unrelated `sorry`s at `:1922`/`:1969` in the same file). Mechanism: **Yoneda on a hom-functor** — `(T ⟶ G⁰) ≃ {f : T ⟶ G | im f ⊆ G⁰}` from the open-immersion lift, then `GrpObj.ofRepresentableBy`.

Negative, for contrast: `Scheme.QuotScheme` (`Picard/QuotRepresentability.lean:73`, `sorry` at `:79`) is the Quot representability statement and is **not** proved — `sorryAx`. And nothing in the tree produces `(DivFunctorDeg π d).RepresentableBy` for AJC's carrier; `Picard/DivFamilyZero.lean:79` explicitly says the degree-0 case is *not* known representable by the terminal object here (the `Subsingleton` half is missing, and the sibling project's route through `IsCertified` does not transport to AJC's `fiberDeg`).

## (C) The `picSharp`-over-separably-closed campaign

**Direct answer to your specific question: there is NO statement in AJC of the form "over a separably closed field / given a rational point, `picSharp` is representable" as a landed theorem — but it is derivable from landed pieces, and the derivation is `sorryAx`.** I wrote the probe:

```lean
theorem probe_sepclosed_picSharp {K} [Field K] [IsSepClosed K] (C : Over (Spec (.of K)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] :
    Scheme.HasPicScheme C := by
  haveI : Scheme.HasRationalPoint C := Scheme.hasRationalPoint_of_isSepClosed C
  exact Scheme.picSchemeOfHasRationalPoint C
```
It elaborates and reports `[propext, sorryAx, Classical.choice, Quot.sound]`. So the separably-closed case is not an independently-proved island: it routes through the same seam `sorry` via `picSchemeOfHasRationalPoint`. The "given a rational point" version is exactly `picSchemeOfHasRationalPoint` (`FGAPicRepresentability.lean:1060`) — **stated, not sorried locally, but `sorryAx`-reachable**.

Landed sorry-free and axiom-clean (all measured):
- `Curve/SeparablyClosedRationalPoint.lean:333` `hasRationalPoint_of_isSepClosed`; `:238` (`SeparablyClosed.exists_rationalPoint_of_smoothOfRelativeDimension_one`), `:307` `exists_rationalPoint_mem`, `:380` `hasRationalPoint_baseChangeField_separableClosure`, `:399` the `GeometricallyIrreducible` variant, `:426`-area irreducibility. This is the "section over `k^s`" input (`I-1135`), and the file states it has **no formal consumers**.
- `Picard/PicEtSubcanonical.lean` §1–§4 entirely: `subcanonical_etaleTopology`, `isIso_picEtComparison_of_isSheaf`, `relPresheaf_isSheaf_of_representableBy`, `picSharp_representableBy_picEt_transport:321`, `hasPicSchemeEt_of_picSharp_representability:344`, `isIso_picEtComparison_of_picSharp_representability:368`, `picSharp_isSheaf_zariski_of_representableBy`, `not_representableBy_picSharp_of_not_isIso_picEtComparison:490`, `not_exists_representing_picSharp_of_not_isIso:506`. File has 0 `sorry`s.
- `Picard/PicEtCrossBase.lean` `picEt_crossBaseIso` (campaign input 2) — clean.
- `Picard/EtaleFieldCover.lean` — the `Spec k' ⟶ Spec k` étale cover and `isSheafFor_picEt_pullback_presieve:308` (G1/G3 descent test).
- G2, partially: `GaloisDescent.hasStableAffineCover_of_orbitsInAffineOpen` (`Picard/StableAffineCover.lean:283`) and `GaloisDescent.hasGaloisQuotient_of_isAffine` (`Picard/GaloisQuotientAffineGeneral.lean:207`) — both clean global instances. G2's residue is the **non-affine** gluing of `Spec(A_U^Γ)` along a stable affine cover, per `FiniteGaloisQuotient.lean`'s own §list.
- G1 machinery, all clean and all taking `rep` as hypothesis: `PicEtGaloisAction.lean` `semilinearGalActionOfRepresentableBy:531`, `representableByTwist:604`, `twistIso:625`; `PicEtQuotientHom.lean` `equivariantToClass:275`, `range_equivariantToClass:327`, `surjective_equivariantToClass_of_subsingleton:361`, `homClassMap_of_galoisQuotient:431` (+ injectivity `:458`).
- `Picard/PicEtDescentRepresentability.lean` `isGalInvariant_of_isCoverCompatible:405` (free) / `isCoverCompatible_of_isGalInvariant:416` (carries `hcov`), plus the assembly + converse above.
- `Picard/PicEtSeparated.lean` `isSeparated_of_representableBy_picEt:194`, `seamClauseOne_of_representableBy_locallyOfFiniteType`, `picEtClauseOne_of_picSharp_representableBy_locallyOfFiniteType` — clean; these reduce clause (1) from three fields to two.

Still OPEN (declaration-level):
- J1–J5 have **no Lean declarations at all**; `SeparablyClosedRationalPoint.lean:353`-area says "cluster `J`'s milestones exist as campaign prose, not as Lean binders".
- G3/G4 as written target `picSharp` over `k` — `PicEtSubcanonical.lean` §4 argues (from a Kleiman quotation, not a Lean proof) that this is expected refutable, and `not_exists_representing_picSharp_of_not_isIso:506` is the reduction that makes it so.
- `hcov` (the `Gal`-indexed section family covering the self-pullback) — undischarged; `PicEtDescentRepresentability.lean:323`/`:330` reduce its last step to joint surjectivity on points.
- G2 non-affine case; the `k^s`-section→finite-Galois-level gap (`Curve/FiniteLevelRationalPoint.lean`, `Curve/GaloisLevelRationalPoint.lean`); Quot endgame `QuotScheme` (off-path).

## (D) `Picard/OnePointRelPicCollapse.lean`

272 lines, **0 `sorry`s**, project-import closure of 23 modules containing **no** sorried module (so nothing leaks in). I probed `relPicQuotAddEquivAbs` and `kerRelPresheafAddEquivKerAbs`: both `[propext, Classical.choice, Quot.sound]`.

What it proves: at a test object `T` whose underlying space is a subsingleton (and nonempty), the relative Picard quotient collapses to the absolute Picard group.
- `Opens.eq_top_of_subsingleton:76` — the one topological input.
- `LineBundle.IsLocallyTrivial.trivial_of_subsingleton:94` — locally trivial ⇒ globally trivial on a one-point scheme.
- `PicSharp.relPicRel_iff_iso_of_subsingleton:118` — the `H_T`-coset relation *is* the absolute iso-class relation.
- `relPicQuotAddEquivAbs:159` / `relPresheafObjAddEquivAbs:186` — `Pic(C ×_S T)/π_T^* Pic(T) ≃+ Pic(C ×_S T)`, additive so `finrank` transports.
- §4: four instances for `Spec k[ε]` and `Spec k`, plus `mem_ker_relPresheaf_iff:232` and `kerRelPresheafAddEquivKerAbs:257` — the dual-number kernel of the relative functor is the dual-number kernel of the absolute group.

**It yields no representability statement at any base, degenerate or otherwise.** The string `RepresentableBy` occurs 0 times in the file; there is no `Over.mk (𝟙 _)` representing claim and no terminal-object argument. It is tangent-space plumbing for the `Pic0` dimension count, not a representability result. (For the shape you may be thinking of — "the functor is representable by the terminal object because its value is a singleton" — the nearest thing in AJC is `DivFamilyZero.lean:79`, which explicitly says it does **not** have that, because only the `Nonempty` half is proved and the `Subsingleton` half is absent for AJC's `DivFamily`.)

Not verified: I did not re-derive the Kleiman citations (real conic, L5105–L5108) — those are quotations in the files, and the files themselves say so. I also did not attempt to reproduce the exact "93 consumers" number.
