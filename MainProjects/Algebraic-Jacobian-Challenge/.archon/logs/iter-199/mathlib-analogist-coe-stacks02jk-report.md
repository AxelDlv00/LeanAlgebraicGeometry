# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
coe-stacks02jk

## Iteration
199

## Structural problem

Closed-point case of Stacks 02JK: for a local `k`-algebra `(S_m, m, κ)`
where `κ/k` is separable (e.g. `k = κ̄` algebraically closed and the
point is `k̄`-rational so `κ = k`), produce a canonical isomorphism of
`κ`-modules `m/m² ≃ κ ⊗_{S_m} Ω[S_m/k]`.

Both failed approaches (iter-198 prover) used only the right half of
the conormal sequence (right-exactness from
`KaehlerDifferential.exact_mapBaseChange_map` or
`exact_kerCotangentToTensor_mapBaseChange`) and lacked the *retraction*
that gives injectivity of the leftmost arrow.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Algebra.FormallySmooth.iff_split_injection` (`Mathlib.RingTheory.Smooth.Basic`) | Commutative algebra | low | ANALOGUE_FOUND |
| `Algebra.Extension.formallySmooth_iff_split_injection` (`Mathlib.RingTheory.Smooth.Basic`) | Commutative algebra (bundled) | low | ANALOGUE_FOUND |
| `Algebra.FormallySmooth.iff_injective_lTensor_residueField` (`Mathlib.RingTheory.Smooth.Local`) | Commutative algebra (local) | medium | ANALOGUE_FOUND |
| `Function.Exact.linearEquivOfSurjective` (`Mathlib.Algebra.Exact`) | Pure module theory | trivial | PARTIAL_ANALOGUE (helper) |
| `Algebra.Generators.cotangentRestrict_bijective_of_basis_kaehlerDifferential` (`Mathlib.RingTheory.Extension.Cotangent.Free`) | Generators / standard-smooth | high | PARTIAL_ANALOGUE |

## Top suggestion

Use **`Algebra.FormallySmooth.iff_split_injection`** from
`Mathlib.RingTheory.Smooth.Basic`. It packages exactly the missing
ingredient — a *retraction* `l : κ ⊗_{S_m} Ω[S_m/k] →ₗ[S_m] m.Cotangent`
satisfying `l ∘ₗ kerCotangentToTensor = id` — as an iff-equivalent of
`Algebra.FormallySmooth R A`, where in our setting `R = k̄`, `P = S_m`,
`A = κ`. The hypothesis `Algebra.FormallySmooth R P` (= `S_m/k̄` FS) is
already supplied by the Stage-4 substrate (smooth ⟹ formally smooth).
The hypothesis `Algebra.FormallySmooth R A` (= `κ/k̄` FS) is automatic
for `κ = k̄` algebraically closed at a `k̄`-rational closed point: it is
literally the identity algebra map.

Proof shape:

```lean
-- Step 1 (retraction → injectivity):
obtain ⟨l, hl⟩ :=
  (Algebra.FormallySmooth.iff_split_injection (R := kbar) (P := S_m) (A := κ)
     hResidueSurjective).mp ‹Algebra.FormallySmooth kbar κ›
have hInj : Function.Injective (KaehlerDifferential.kerCotangentToTensor kbar S_m κ) :=
  fun _ _ heq => by
    have := congr_arg (fun f => f _) hl
    -- standard left-inverse → injective
    ...

-- Step 2 (Ω[κ/k̄] = 0 + right-exactness → surjectivity):
have hΩκ : Subsingleton (Ω[κ⁄kbar]) := by
  -- κ = kbar, so algebraMap kbar κ is surjective (identity)
  exact KaehlerDifferential.subsingleton_of_surjective kbar κ ‹Surjective _›
have hExact : Function.Exact ⇑(KaehlerDifferential.kerCotangentToTensor kbar S_m κ)
                              ⇑(KaehlerDifferential.mapBaseChange kbar S_m κ) :=
  KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange kbar S_m κ hResidueSurjective
-- target of mapBaseChange is Ω[κ/k̄] = 0, so kerCotangentToTensor is surjective

-- Step 3 (bijective → linear equivalence):
have hIso : (maximalIdeal S_m).Cotangent ≃ₗ[S_m] κ ⊗[S_m] Ω[S_m⁄kbar] :=
  LinearEquiv.ofBijective _ ⟨hInj, hSurj_kct⟩
```

The first file to touch is
`AlgebraicJacobian/Albanese/CodimOneExtension.lean` around line 615
(where the iso is currently the unresolved sub-gap (ii.A)). Extract the
iso as a fresh private theorem
`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` and
consume it in `isRegularLocalRing_stalk_of_smooth` via
`LinearEquiv.finrank_eq` against the already-landed
`_hFinrankResidueTensor : finrank κ (κ ⊗ Ω[S_m/R]) = n` substrate.

Estimated total LOC: 40–70, well below the directive's 100–200 estimate
because Mathlib's iff-lemma supplies the retraction "for free" — no
manual section construction is needed.

The κ-linearity upgrade (from the natively `S_m`-linear `kerCotangentToTensor`)
threads through `IsLocalRing.instModuleResidueFieldCotangentSpace` and
`IsLocalRing.instIsScalarTowerResidueFieldCotangentSpace`, which are
both Mathlib instances. If that thread snags, fall back to the
`Algebra.Extension`-packaged form
(`Algebra.Extension.formallySmooth_iff_split_injection`) which carries
the residue-field module structure cleanly through
`Algebra.Extension.CotangentSpace`'s built-in `S`-module structure.

## Discarded

- **`KaehlerDifferential.exact_mapBaseChange_map` alone**: matches the
  iter-198 failed approach (1) — gives right-exactness only.
- **Pure conormal `kerCotangentToTensor` + `Ω[κ/k̄] = 0` without an FS
  retraction**: matches the iter-198 failed approach (2) — no injectivity
  obtainable.

## Persistent file
- `analogies/coe-stacks02jk.md` — analogue list captured for future iters.

Overall verdict: three structural analogues found, all in
`Mathlib.RingTheory.Smooth.{Basic,Local}`; the iff-equivalence of
"formally smooth" with "cotangent-map retraction exists" is the missing
ingredient that closes the closed-point case in 40–70 LOC.
