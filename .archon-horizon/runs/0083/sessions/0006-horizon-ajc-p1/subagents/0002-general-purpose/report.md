All probes elaborated; no file under `AlgebraicJacobian/` was touched (both target files remain untracked-as-before, no diff). Scratch removed.

---

## (A) `Scheme.Pic0Et.universallyClosed` — `AlgebraicJacobian/Picard/Pic0Et.lean:223-228`

```lean
theorem universallyClosed {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
    UniversallyClosed (Pic0SchemeEt C).hom :=
  sorry
```

**VERDICT: reducible-to-X, two ways, both measured.** The docstring's prescription (Kleiman §5 `th:qpp&p`, "projectivity upgrade") is *not* the cheapest route and no projectivity vocabulary is needed.

Probe `/tmp/ProbeA.lean`, EXIT=1 with **exactly two errors, both my planted controls** (`example : (2:Nat) = 3 := by rfl` → ``Tactic `rfl` failed: The left-hand side 2 is not definitionally equal to the right-hand side 3``; and `infer_instance` for the goal → ``failed to synthesize instance of type class UniversallyClosed (Scheme.Pic0SchemeEt C).hom``). Every substantive theorem in the file produced zero diagnostics, and the control-free rerun gave EXIT=0 with all four **axiom-clean** `[propext, Classical.choice, Quot.sound]`:

- `probeA_quasiCompact` — `QuasiCompact (Pic0SchemeEt C).hom` is **free**, from `GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible (PicSchemeEt C)).2.1`. This is the missing side condition, and the engine is stated for an **arbitrary** `G` (`IdentityComponent.lean:1343`, binders `(G : Over (Spec (.of k))) [GrpObj G] [LocallyOfFiniteType G.hom]`) — fully transportable.
- `probeA_universallyClosed_of_valuativeCriterion` — `ValuativeCriterion.Existence (Pic0SchemeEt C).hom → UniversallyClosed …`, via mathlib `UniversallyClosed.of_valuativeCriterion`.
- `probeA_proper_of_valuativeCriterion` — the valuative criterion alone yields **full `IsProper`**, i.e. it discharges the whole `proper` obligation, not just this conjunct.
- `probeA_universallyClosed_of_baseChange` — fpqc descent to `k̄` via `MorphismProperty.of_pullback_snd_of_descendsAlong`, also free.

picSharp-side twins exist and are proved: `Pic0.universallyClosed_of_valuativeCriterion` (`Pic0AbelianVariety.lean:1418`), `Pic0.proper_of_valuativeCriterion`, `Pic0.universallyClosed_of_baseChange` (:642), `Pic0.quasiCompact` (:620). All carry `[HasPicScheme C]`, but their supporting engines are generic, so the étale restatement is the three-line transport I just ran.

One recorded route is **refuted, not merely unproven**: `Pic0.universallyClosed_of_ambient` has an unsatisfiable antecedent — `Picard/AmbientPicNotProper.lean` proves `Pic_{C/k}` is an infinite disjoint union over `deg ∈ ℤ`, hence not quasi-compact, hence not universally closed. Do not spend a lane on the ambient object.

remaining mathematical content is: `ValuativeCriterion.Existence (Pic0SchemeEt C).hom` — every DVR-valued point of the base lifts, i.e. an invertible sheaf on `C ×_k Spec K` extends over the valuation ring.

## (B) `Scheme.Pic0Et.geometricallyReduced` — `Pic0Et.lean:170-175`

```lean
theorem geometricallyReduced {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
    GeometricallyReduced (Pic0SchemeEt C).hom :=
  sorry
```

**VERDICT: reducible-to-X. I-0944 is CORRECT, including its import warning.** Probe EXIT=1 with **only the two controls failing** — verbatim: ``/tmp/ProbeB.lean:29:2: error(lean.synthInstanceFailed): failed to synthesize instance of type class GeometricallyReduced (Scheme.Pic0SchemeEt C).hom`` and the planted `2 = 3`. Control-free rerun: **EXIT=0**, and `#print axioms` gives `[propext, Classical.choice, Quot.sound]` for both

- `probeB_geometricallyReduced : IsReduced (Limits.pullback (Pic0SchemeEt C).hom (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k))))) → GeometricallyReduced (Pic0SchemeEt C).hom`
- `probeB_smooth` — same hypothesis → `Smooth (Pic0SchemeEt C).hom`.

Body of the first: `haveI := Pic0Et.locallyOfFiniteType C`, `letI := (Pic0Et.grpObj C).some`, `haveI := smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange (Pic0SchemeEt C).hom h`, then `infer_instance`.

The engine `smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange` (`GroupSchemeSmoothAlgClosed.lean:156`) binds `{G : Scheme} (f : G ⟶ Spec (.of K)) [LocallyOfFiniteType f] [GrpObj (Over.mk f)]` — **arbitrary group scheme, transportable**, confirmed by `#check`. The import warning is real: the `Smooth.geometricallyReduced` instance lives at `AlgebraicJacobian/Curve/GeometricallyReduced.lean:142` and that module is *not* in Pic0Et's cone. It imports only mathlib files, so adding it creates no cycle. picSharp twins already landed: `Pic0.smooth_of_isReduced_algebraicClosureBaseChange` and `Pic0.geometricallyReduced_of_isReduced_algebraicClosureBaseChange` (`Pic0AbelianVariety.lean:1233`/`:1264`).

Because `Pic0Et.smooth` (:179) is already an assembly over `geometricallyReduced`, this one hypothesis kills both legs.

remaining mathematical content is: `IsReduced (Pic0SchemeEt C ×_{Spec k} Spec k̄)` — Cartier in char 0, `H²(C, 𝒪_C) = 0` unobstructedness in char p.

## (C) `isAlbanese_pic0Et` — `AlgebraicJacobian/Jacobian.lean:576-583`

```lean
theorem isAlbanese_pic0Et (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (grp : GrpObj (Scheme.Pic0SchemeEt C)) (pr : IsProper (Scheme.Pic0SchemeEt C).hom)
    (sm : Smooth (Scheme.Pic0SchemeEt C).hom)
    (gi : GeometricallyIrreducible (Scheme.Pic0SchemeEt C).hom)
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
    @IsAlbanese k _ C P (Scheme.Pic0SchemeEt C) grp pr sm gi :=
  sorry
```
Note `[HasPicSchemeEt C]` is *absent* — it fires from the unconditional `instHasPicSchemeEt` (`FGAPicRepresentability.lean:508`), whose body is `⟨(fgaPicardRepresentability C).1⟩`, i.e. the representability sorry.

**VERDICT: no-reduction-found.** Nothing exists to cut it. Measured facts:

- **`Pic0.abelJacobi` exists but is `sorry`-bodied** (`Albanese/AlbaneseUP.lean:435-437`, body literally `sorry`), and it is stated only for `{kbar} [Field kbar] [IsAlgClosed kbar]` into `jacobianScheme C` = `Scheme.Pic0Scheme C` — the `picSharp` object over an *algebraically closed* field. There is **no étale-side Abel–Jacobi morphism at all**: `horizon search` returns exactly two `abelJacobi` hits (this one and its `SubProjects/Albanese` copy), zero mentioning `Pic0SchemeEt`.
- `Scheme.PicScheme.abelMap` **does** exist and is sorry-free (`FGAPicRepresentability.lean:846`), but it is `divFunctor C ⟶ picSharp C` — a natural transformation of *functors* on the unsheafified side, not a scheme morphism `C ⟶ Pic0SchemeEt C`. It is not the missing object.
- **`isAlbanese_pic0` (:546-554) is also bare `sorry`** — the picSharp twin is not proved, so there is nothing to transport even in principle. `AlbaneseUP.lean` carries 6 sorries (:437, :484, :529, :566, :623, :660) and `albanese_universal_property` itself reports `[propext, sorryAx, Classical.choice, Quot.sound]`.
- The one thing that *is* free: my `probeC_transport` (EXIT=0, axiom-clean `[propext, Classical.choice, Quot.sound]`) proves `IsAlbanese` transports along any iso `J₁ ≅ J₂` respecting the identity. So the docstring's "carrying `Pic0.abelJacobi` to `Pic0SchemeEt` is part of this leaf" costs nothing *once* an iso `Pic0Scheme C ≅ Pic0SchemeEt C` exists — and no such comparison iso exists by name (searched; only `picEtComparison`-adjacent material, itself flagged broken by I-1019). Over general `k` the two objects are not isomorphic anyway.
- `probeC_from_abelJacobi` (EXIT=0, axiom-clean once `[HasPicSchemeEt C]` is bound explicitly) confirms the statement is *exactly* `∃ α, P ≫ α = η ∧ universal-factorisation` with no hidden cast: the `grp/pr/sm/gi`-as-arguments vs instances mismatch costs nothing. So the sorry is not a bookkeeping artifact.

remaining mathematical content is: construct `α : C ⟶ Pic0SchemeEt C` with `P ≫ α = η` over an **arbitrary** field, and prove it universal — i.e. build the Abel–Jacobi morphism étale-side from scratch (the moduli classifier of `𝓞_{C×C}(Δ − {P}×C − C×{P})`), then Galois descent from `k̄` plus Mumford §4 rigidity for `genus C = 0`.

## Ranking by value/cost

**B ≫ A ≫ C.** B and A are both now three-line transports of already-landed generic engines, but B is strictly better: one hypothesis (`IsReduced` of one scheme over `k̄`) discharges *two* of the five headline obligations (`geometricallyReduced` and, through the existing assembly, `smooth`), and its engine and import fix are already verified; A buys one obligation for one hypothesis (`ValuativeCriterion.Existence`) — still cheap, and its `QuasiCompact` side condition turned out free — while C has no reduction, no étale Abel–Jacobi morphism to transport, and a `sorry`-bodied twin, so it is the largest genuinely unbuilt piece of the five.
