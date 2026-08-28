All three re-verified at the restored HEAD (`58fe62c9…`, HEAD==disk), EXIT=0 each, no output. Files were never cleared — verbatim contents below, with hashes so you can confirm what I ran is what you're reading.

## 1. `/tmp/probe_overk4.lean` (md5 `d5a6bc4d845fa8d6b46f1e293f92eea4`)

```lean
import AlgebraicJacobian.Curve.FiniteLevelRationalPoint
set_option maxHeartbeats 2000000
universe u
open CategoryTheory AlgebraicGeometry IntermediateField Limits
namespace ProbeOverK4

theorem base_tri {k : Type u} [Field k] (k' : IntermediateField k (SeparableClosure k)) :
    Spec.map (CommRingCat.ofHom (k'.val.toRingHom)) ≫
      Spec.map (CommRingCat.ofHom (algebraMap k k')) =
    Spec.map (CommRingCat.ofHom (algebraMap k (SeparableClosure k))) := by
  rw [← Spec.map_comp]; congr 1

-- FULL: is "q is a k'-morphism" derivable from the theorem's conclusion?
theorem over_k' {k : Type u} [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (CommRingCat.of k))
    (p : Spec (CommRingCat.of (SeparableClosure k)) ⟶ X)
    (hp : p ≫ f = Spec.map (CommRingCat.ofHom (algebraMap k (SeparableClosure k))))
    (k' : IntermediateField k (SeparableClosure k))
    (q : Spec (CommRingCat.of k') ⟶ X)
    (hq : Spec.map (CommRingCat.ofHom (k'.val.toRingHom)) ≫ q = p) :
    q ≫ f = Spec.map (CommRingCat.ofHom (algebraMap k k')) := by
  have hepi : Epi (Spec.map (CommRingCat.ofHom (k'.val.toRingHom))) :=
    Flat.epi_of_flat_of_surjective (Spec.map (CommRingCat.ofHom k'.val.toRingHom))
  apply hepi.left_cancellation
  rw [← Category.assoc, hq, hp, base_tri]

end ProbeOverK4
```

On your failing `exact?`: **the epi is not coming from synthesis for me either.** Two things differ from what you tried.

First, the carrier. You probed `Epi (Spec.map (CommRingCat.ofHom (A.val.toRingHom)))` for `A : Subalgebra k Ks`. Mine is `k' : IntermediateField k (SeparableClosure k)`, so `k'.val` is an `IntermediateField` field embedding and `↥k'` carries a `Field` instance. That is what makes the flatness and surjectivity side conditions discharge by instance search. At the `Subalgebra` level `↥A` is only a `CommRing` until you have transported it through `exists_intermediateField_toSubalgebra_eq` — so land this **after** the `IntermediateField` step, never at §3's subalgebra. That ordering is load-bearing.

Second, `Flat.epi_of_flat_of_surjective` was not found by `exact?` on the `Epi` goal directly. It came from `exact?` on a *different* goal — line 12 of `/tmp/probe_overk3.lean`, where I had left a `congr 1` that closed early, and Lean's error was `No goals to be solved` followed by a `Try this:` for the epi goal below it. I then supplied it explicitly as a `have`, which is why the final proof names it rather than using `inferInstance`. Do not expect synthesis to produce it; write the `have`.

Also note `base_tri`'s proof is `rw [← Spec.map_comp]; congr 1` — nothing more. In an earlier draft I had `congr 1; ext r; rfl`, and the `ext r; rfl` produced `No goals to be solved`; `congr 1` alone closes it. If you paste the longer version it will fail.

## 2. `/tmp/probe_hrp2.lean` (md5 `ed5b9fe3d468597ec0405b6e8ecad807`)

```lean
import AlgebraicJacobian.Curve.FiniteLevelRationalPoint
set_option maxHeartbeats 2000000
universe u
open CategoryTheory AlgebraicGeometry IntermediateField Limits
namespace ProbeHRP2

theorem hrp_of_finiteLevel {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    (k' : IntermediateField k (SeparableClosure k))
    (q : Spec (CommRingCat.of k') ⟶ C.left)
    (hqf : q ≫ C.hom = Spec.map (CommRingCat.ofHom (algebraMap k k'))) :
    Scheme.HasRationalPoint (Scheme.baseChangeField C k') := by
  refine ⟨⟨⟨pullback.lift q (𝟙 _) (by simpa using hqf), ?_⟩⟩⟩
  show pullback.lift q (𝟙 _) _ ≫ pullback.snd _ _ = _
  exact pullback.lift_snd _ _ _

end ProbeHRP2
```

Two things to preserve. The `show` line is not cosmetic — it forces the `Scheme.baseChangeField`/`Over.mk` layer to unfold so `pullback.lift_snd` matches; without it the goal is stated at `(baseChangeField C k').hom` and the `exact` fails on the same `Quiver.Hom` carrier mismatch I hit repeatedly. And the last step is `exact pullback.lift_snd _ _ _`, not `simp` — plain `simp` reports `made no progress` there (that was the only error in the first draft).

Note the binders: **no** `[SmoothOfRelativeDimension 1 C.hom]`, no properness, no irreducibility. `C` is an arbitrary object over `Spec k`. This is pure pullback universal property, so don't add curve hypotheses it doesn't consume.

## 3. `/tmp/probe_inhab6.lean` (md5 `921711e2e1b049432ec7b2c8d43a67b1`)

```lean
import AlgebraicJacobian.Curve.FiniteLevelRationalPoint
universe u
open CategoryTheory AlgebraicGeometry IntermediateField Limits
namespace ProbeInhab6

theorem finite_level_reached {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k))) [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] :
    ∃ (k' : IntermediateField k (SeparableClosure k)) (_ : FiniteDimensional k k')
      (_ : Algebra.IsSeparable k k') (q : Spec (CommRingCat.of k') ⟶ C.left)
      (p : Spec (CommRingCat.of (SeparableClosure k)) ⟶ C.left),
      Spec.map (CommRingCat.ofHom (k'.val.toRingHom)) ≫ q = p ∧
      p ≫ C.hom = Spec.map (CommRingCat.ofHom (algebraMap k (SeparableClosure k))) := by
  haveI := Scheme.hasRationalPoint_baseChangeField_separableClosure_of_geometricallyIrreducible C
  obtain ⟨σ0, hσ0⟩ := (Scheme.HasRationalPoint.nonempty_section
    (C := Scheme.baseChangeField C (SeparableClosure k))).some
  let g := Spec.map (CommRingCat.ofHom (algebraMap k (SeparableClosure k)))
  let σ : Spec (CommRingCat.of (SeparableClosure k)) ⟶ pullback C.hom g := σ0
  have hσ : σ ≫ pullback.snd C.hom g = 𝟙 _ := hσ0
  have hp : (σ ≫ pullback.fst C.hom g) ≫ C.hom = g := by
    rw [Category.assoc, pullback.condition, ← Category.assoc, hσ, Category.id_comp]
  obtain ⟨k', hfd, hsep, q, hq⟩ :=
    Scheme.exists_finiteSeparable_level_factorization C.hom (σ ≫ pullback.fst C.hom g) hp
  exact ⟨k', hfd, hsep, q, σ ≫ pullback.fst C.hom g, hq, hp⟩

end ProbeInhab6
```

To your explicit question: **`[GeometricallyIrreducible C.hom]`, the irreducible form**, plus `[SmoothOfRelativeDimension 1 C.hom]`. That is deliberate, not incidental — it's the binder `Challenge.lean` and `picardJacobianWitness` actually carry, so a consumer needs no bridging instance. It routes through `hasRationalPoint_baseChangeField_separableClosure_of_geometricallyIrreducible`. The integral form would work equally well via `hasRationalPoint_baseChangeField_separableClosure`, but then a challenge-shaped caller has to supply an `IsIntegral` bridge. I did not measure the integral variant, so treat "it would work" as unverified reasoning, not a result.

The coercion handling is the fragile part, and it cost me three failed drafts. `Scheme.HasRationalPoint.nonempty_section` hands you `σ0` typed at `(Scheme.baseChangeField C (SeparableClosure k)).left`, but `pullback.fst`/`pullback.condition` need it typed at `pullback C.hom g`. The fix is the `let σ : … ⟶ pullback C.hom g := σ0` retyping plus restating `hσ` — both definitionally free. What does **not** work is `simp only [Scheme.baseChangeField, Over.mk_left, Over.mk_hom] at σ hσ`: that introduces a *second* hypothesis (`σ✝` alongside `σ`) and every later `rw` then reports "Did not find an occurrence" while the goal visibly contains the pattern. Two of my drafts died there; it's the same shape as the `subring-under-a-letI-action` lesson in my memory.

One caveat on the statement as written: I bundled `p` into the existential so the conclusion could carry `hp` and be self-contained for measurement. For landing, you probably want `p` expressed as `σ ≫ pullback.fst …` in the proof only, with the conclusion just asserting the finite level and `q` — but that changes the statement, so re-measure rather than assuming my EXIT=0 transfers.

Two standing items from the audit that this hand-off does not close: the three unresolvable docstring names (including the "recorded below and proved" sentence, which landing `hrp_of_finiteLevel` will finally make true), and `not_isSepClosed_rat` still proving a proposition adjacent to the §5 claim — the `IsSepClosed k ← (⊥ = ⊤)` direction remains unfound. `[IsProper C.hom]` on `level_factorization_of_curve` is still unused.
