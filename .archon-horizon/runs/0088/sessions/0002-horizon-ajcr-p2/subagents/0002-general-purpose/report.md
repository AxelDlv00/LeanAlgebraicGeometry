Investigation complete. Findings below.

## 1. The two headline declarations

Both in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartCoveragePointwise.lean`. File-level binders (lines 67-69) apply to both: `{k : Type u} [Field k] {C : Over (Spec (.of k))}`, `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, plus `variable (C) in` making `C` explicit.

**B-5 ⟹ B-6, line 145:**
```lean
theorem isLocallySurjective_sigmaDesc_of_pointwise {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (h : ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T),
      ∃ (W : T.Opens) (_ : t ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ X i),
        (f i).app (op (W : Scheme.{u})) x = (pic0SigmaSheaf C).1.map (W.ι).op s) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f) :=
  isLocallySurjective_sigmaDesc f (chartsCoverLocally_of_pointwise C f h)
```

**Converse, line 173:**
```lean
theorem pointwise_of_chartsCoverLocally {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (h : ChartsCoverLocally C f) (T : Scheme.{u})
    (s : (pic0SigmaSheaf C).1.obj (op T)) :
    ∃ (𝒰 : T.Cover.{u} (Scheme.precoverage @IsOpenImmersion)),
      ∀ j : 𝒰.I₀, ∃ (i : ι) (x : 𝒰.X j ⟶ X i),
        (f i).app (op (𝒰.X j)) x = (pic0SigmaSheaf C).1.map (𝒰.f j).op s
```

The converse is genuinely weaker than the forward hypothesis in a way its own docstring (lines 166-172) names: it returns a cover by *arbitrary* schemes with open-immersion maps, not by opens of `T`, and it drops the per-point `t ∈ W` localization (quantifies over cover members `j`, not points). So it is not a clean iff. Supporting lemmas: `mem_zariskiTopology_iSup_of_pointwise` (line 92, the site-theoretic bridge, no chart content) and `chartsCoverLocally_of_pointwise` (line 128, same `h`, concludes `ChartsCoverLocally C f`).

Both verify with axioms `[propext, Classical.choice, Quot.sound]` only; file elaborates with zero diagnostics, 0 `sorry`, and is in the root import (`AlgebraicJacobian.lean:566`).

## 2. What B-5 actually is

There is no named `Prop` for it. B-5 is the **anonymous inline `h`** quoted above — not a definition, so it cannot be grepped by name. The named predicate one level down is `ChartsCoverLocally`, at `AlgebraicJacobian/Picard/Pic0ChartLocalSurjectivity.lean:86`:
```lean
def ChartsCoverLocally {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)),
    (⨆ i, Presheaf.imageSieve (f i) s) ∈ Scheme.zariskiTopology T
```
A producer of B-5 must exhibit, for **every** bare scheme `T`, **every** section `s`, and **every** point `t : ↥T`, four things: an open `W : T.Opens`; a proof `t ∈ W`; an index `i : ι`; and a morphism `x : ↑W ⟶ X i` whose chart value equals `s|_W`. Per `Pic0ChartCoverageAbel.lean:26-31`, that last equation is *two* equations at the Abel chart, since sections of `pic0SigmaSheaf` are `Sigma.mk` pairs: the Σ-component `x ≫ D.hom` must match, and only then are the classes in the same type. `abelChartApp_eq` (`Pic0ChartCoverageAbel.lean:105`) records this.

## 3. `exists_mem_chartLocus_of_vanishing_bound` — the gap is large

`AlgebraicJacobian/Picard/Pic0ChartCoverageNoDrop.lean:214`. Conclusion:
```lean
    ∃ m' : ℕ, ∃ Z' : (C ⊗ overSpec k k).left.CurveDivisor, t ∈ chartLocus C m' Z' lam
```
Hypotheses: `{T : Over (Spec (.of k))}`, `lam : picEt C T`, `t : T.left`, `m : ℕ`, `Z`, a splitting field `{L}` with `[Field L] [Algebra k L] [Algebra (Over.testPointField t) L] [IsScalarTower k (Over.testPointField t) L] [Module.Finite (Over.testPointField t) L] [Algebra.IsSeparable (Over.testPointField t) L]`, a presenting Čech class `M₀` with `hM₀`, five re-keyed base-change instances, then `(b : ℤ)`, `hb` (every divisor of degree `≥ b` on `C_L` has `Subsingleton H¹`), and `hdeg`.

Four independent gaps to B-5, in increasing cost:

- **Test category.** It concludes over `T : Over (Spec (.of k))`; B-5 quantifies over bare `T : Scheme.{u}` with a section `s = ⟨a, λ⟩`. `Pic0ChartCoverageAbel.lean:18-24` argues this crossing is definitionally free (`(Over.mk a).left` is `T`).
- **No `W`.** It gives membership at a single point, not an open neighbourhood. Producing `W` is `chartLocusOpens`, which costs `haff` = `ChartLocusAffineLocal` (`Pic0ChartCoverageAbel.lean:132`), reduced to B-4's `IsChartDatumPresentation` per affine piece by `chartLocusAffineLocal_of_presentation` (line 182, needs `[IsFinite π]`). `Pic0ChartCoverageAbel.lean:40` explicitly corrects the sibling claim that "the `W` field costs zero" as **false**.
- **No `x`.** This is the biggest hole and the one nothing addresses. `t ∈ chartLocus` says a split witness divisor *exists over a field extension of κ(t)*; B-5 needs an actual scheme morphism `↑W ⟶ X i` over the whole open. **No declaration anywhere in the project produces `x` from locus membership** — I grepped `chartLocus` against `abelSigmaChart`/`chartValue`/`range`/`surjective` and found nothing. Going from the pointwise field-level witness to a family over `W` is unbuilt.
- **`hb` is not available at the parameter that matters.** `Pic0ChartCoverageIndexSlack.lean` machine-checks that `hdeg` forces `b = n` (`ledger_forces_b_eq_n:119`), and that at `n = g` the resulting `hb` forces every degree-`g` divisor to have `h⁰ = 1` (`hb_forces_h0_eq_one:180`) — false on a curve with a moving degree-`g` family. `index_of_threshold:147` shows `hdeg` is satisfiable at `n := b.toNat`, so it is not blocked, but the reconciliation at `n = g` is the open residue.

## 4. Producers: none

**No declaration in the project produces the pointwise hypothesis, `ChartsCoverLocally`, or the `IsLocallySurjective` instance — not even conditionally.** `ChartsCoverLocally` appears as a *hypothesis* at `Pic0ChartLocalSurjectivity.lean:105` and `Pic0ChartCoveragePointwise.lean:175`, as a *conclusion* only from other hypotheses at `:128` (from B-5) and `:128` of the surjectivity file (`chartsCoverLocally_of_forall_surjective`, from a chart surjective on every test — explicitly labelled the degenerate non-geometric case, its docstring at line 119 says "no single Abel chart is surjective on all tests").

## 5. Vacuity: genuinely non-vacuous

Machine-checked, not inferred. With `ι := PEmpty.{u+1}` the hypothesis is provably `False`:

```lean
theorem pointwise_empty_iota_false
    (X : PEmpty.{u + 1} → Scheme.{u}) (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (h : ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T), ...) : False := by
  obtain ⟨t⟩ := (inferInstance : Nonempty (↥(Spec (CommRingCat.of k) : Scheme.{u})))
  obtain ⟨W, hW, i, x, hx⟩ := h _ (⟨𝟙 _, 1⟩ : ...) t
  exact i.elim
```
This compiles (only a line-length lint). `Spec k` is a nonempty scheme by instance, and `⟨𝟙 _, 1⟩` is a section of `pic0SigmaSheaf C` over it, so a witness triple `(T, s, t)` always exists and the `∃ i : ι` cannot be met. The hypothesis genuinely requires the charts to cover.

## 6. The three carrier files — one line number is wrong

- `AlgebraicJacobian/Picard/JacobianDataCharts.lean:117` — **confirmed**, `variable [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]`.
- `AlgebraicJacobian/Picard/JacobianDataAbelSurj.lean:183` — **confirmed**, identical text.
- `AlgebraicJacobian/Picard/JacobianDataAbelImage.lean:131` — **wrong**. Line 131 is `(hlft : LocallyOfFiniteType J.hom)`. The `variable` is at **line 146**. The stale citation is reproduced verbatim in `Pic0ChartCoverageNoDrop.lean:20-21` and `Pic0ChartCoveragePointwise.lean:144`'s docstring claim about "three files".

A fourth site the "three files" framing omits: `Pic0ChartAtlasParamFree.lean:133` carries the same instance as an unproduced binder on `mixedParamRepresentableBy`, and `Pic0SigmaSheaf.lean:165` is the consumer itself.

## Bottom line

B-6 is fully reduced to B-5 and the reduction is sound, non-vacuous, and sorry-free — the site-theoretic layer is genuinely gone. B-5 itself is an unnamed inline hypothesis nobody produces. The nearest existing result reaches only pointwise locus membership over slice tests; the distance to B-5 is `W` (costs B-4's presentation residue), `hb` (not true at `n = g`), and above all the chart morphism `x : ↑W ⟶ X i`, for which no partial result exists anywhere in the project.
