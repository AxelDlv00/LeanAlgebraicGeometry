Both items filed (I-0549 and one memory item). Here are my findings.

## The central claim, adjudicated

**(d) the axiom measurement is sound. (a)–(c) is honest work but the anti-vacuity argument is overstated — and one part of it is refutable.**

You asked me to apply `ajc-albanese-frontier`'s lesson against you. It applies, but in the mirror image of what you feared: `SymPowData` is not uninhabitable at g ≥ 2, it is *too easily* inhabitable at every n, which makes `symPowDataOne` worthless as evidence.

### 1. SymPowData does not pin the symmetric power (most severe)

`SymPowData C n` (`/home/axel/.../AlgebraicJacobian/Albanese/SymPowInterface.lean:94`) requires a carrier, a `proj`, and unique factorisation of S_n-symmetric morphisms — but never that `proj` itself is S_n-invariant. So the identity inhabits it for **every** n:

```lean
noncomputable def symPowDataTrivial (C : K) (n : ℕ) : SymPowData C n where
  carrier := ∏ᶜ (fun _ : Fin n => C)
  proj := 𝟙 _
  desc := fun {T} h _ => ⟨h, by simp, fun u hu => by simpa using hu⟩
```

That typechecks with zero errors (`lake env lean` on a scratch file importing `SymPowInterface`). `symPowDataOne` is therefore not evidence that the interface is inhabitable at g ≥ 2 — inhabiting the *structure* says nothing at all, at any n.

What carries the content is the separate binder `hproj : ∀ σ, permAut C σ ≫ D.proj = D.proj`, which the trivial datum fails at n = 2 and which is not derivable from the structure. So the honest object is the pair `(SymPowData, hproj)`, and only the pair at n = 1 has been inhabited. Fix: move `hproj` into the structure as a field. `symPowDataOne` still goes through (S_1's `permAut` is the identity up to `Subsingleton.elim` — I checked). Filed as I-0549.

This is not fatal. The real Sym^n C satisfies both clauses, and nothing downstream is vacuously discharged (see 3). The overstatement is narrowly the claim that `symPowDataOne` rules out vacuity where it matters.

### 2. The one exhibited inhabitant is the tautological case

`symPowDataOne` has `carrier := C`, so `Sym^1 φ = φ` on the nose — provable:

```lean
theorem symAVMapOne (C A : K) [MonObj A] [IsCommMonObj A] (φ : C ⟶ A) :
    (symPowDataOne C).symAVMap φ = φ
```

Consequently at n = 1 `hdesc` **is** the conclusion: `rw [symAVMapOne]` on the biconditional between the two `∃!` statements leaves a goal whose sides are syntactically identical. So the n = 1 case does not exercise the argument at all.

### 3. hdesc: not circular, but inter-derivable — so the weight is elsewhere

You asked whether `hdesc` already contains the conclusion. It does not *contain* it, but under the same auxiliary hypotheses the converse holds — I proved it, sorry-free, in six lines from your two connector directions (same `D, f, P0, i₀, hproj, aj, hf, haj0, φ, hφ, hom`). So `exists_unique_albanese_factorisation` is a transport across an equivalence, not a strengthening. That is legitimate (Milne's step 5 transporting step 2), and your docstring says as much. But it means the leg's mathematical weight sits in *producing* `hdesc` — which is `exists_unique_descent_of_birational`, from the commits after the five I was given. That, not the connector, is the session's strongest result.

`lean_minimal_hypotheses` on both `exists_unique_albanese_factorisation` and `exists_unique_descent_of_birational`: **every explicit hypothesis load-bearing, none unused.** No finding there.

### 4. The axiom measurement holds up

Re-run independently:

```
albanese_universal_property_of_symPowData_generic  -> [propext, Classical.choice, Quot.sound]
Pic0.albanese_universal_property_of_symPowData     -> [propext, sorryAx, Classical.choice, Quot.sound]
Pic0.albanese_universal_property (control)         -> sorryAx
Pic0.abelJacobi (control)                          -> sorryAx
Pic0.jacobianScheme + all four jacobianScheme_*    -> sorryAx
```

Controls live, so the probe is not blind. Binder comparison line by line: the generic form drops three *curve* instances on `C` the specialised proof never uses, generalises `genus C` to arbitrary `g`, and **adds** the four-instance AV package on `J` — which the specialised form obtains from the `sorryAx`-carrying `jacobianScheme_*` lemmas. It assumes more about the target and less about `C`. Nothing was weakened to buy cleanliness. Attribution to the Picard seam is correct.

### 5. AVSelfProduct verified

All six declarations axiom-clean, file sorry-free, three rewrites are exactly as described. `isCommMonObj_of_isProper_smooth_of_package` and `isMonHom_of_pointed` carry only `[GrpObj] [IsProper] [Smooth] [GeometricallyIrreducible]` (the latter plus `[GrpObj B] [IsProper B.hom]` on the codomain, which is correct). The recorded dead end was genuinely a keying problem. No overstatement here.

### 6. Overstatement check and sorry counts

Counts confirmed by kernel, not grep: `lake build` reports exactly 6 `declaration uses sorry` in AlbaneseUP (lines 396, 440, 485, 524, 576, 612), 0 in all four new files; full build green, 8678 jobs. The `AlbaneseJacobian.lean` header disclaimer is properly worded — a reader will not come away believing the Jacobian result is closed. The commit messages are measured.

Three docstring claims a reader would over-believe, all traceable to finding 1: `SymPowInterface.lean:49-53`, `:216-221`, `:226-228`, plus `AlbaneseUP.lean:74-76` ("**inhabits** the interface ... so statements quantifying over it are not vacuous").

### 7. Stale material

`DenseOpenDescent.lean:39-42` still says mathlib has no birational-inverse API and "the `Pic⁰ ⇢ A` rational map cannot yet be produced." `AlbaneseUP.lean:573` says the same. Your own commit `1259745c3` retired that framing in `AlbaneseFromData.lean` — these two are the stale survivors, and they are exactly the kind of claim your commit `28f1f18a9` was written to prevent.

Blueprint disagreement: node `thm:albanese_universal_property` is `lean_ok`, formalized by `Pic0.albanese_universal_property` — the `sorryAx` version quantifying over a sorry-bodied `abelJacobi`. The graph reports the leg as proved. `lem:symmetric_product_av_map` is `lean_status: empty` despite `SymPowData.symAVMap` now existing.

Roadmap: `AJC.albanese.symmetric` is `blocked`, `AJC.albanese.universal` is `active`. Both are stale relative to this session.

## Highest-value next action

Move `hproj` into `SymPowData` as a field. It is a small edit, it converts the anti-vacuity claim from refutable to true, it makes every downstream signature shorter, and it is the one finding that changes what the leg's headline means. Do it before the `lean_ok` on `thm:albanese_universal_property` is retargeted at the new theorems — otherwise the graph will record a proved Albanese universal property standing on a structure that the identity morphism satisfies.

Two housekeeping notes: the inbox is at 60 open non-protection items against a limit of 30, and I did not review the RiemannRoch or Picard lanes (other teams are live in them).
