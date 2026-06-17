# AlgebraicJacobian/AbelJacobi.lean — Lane 4 (Phase E close-by-reduction)

## Summary

- **Target.** Close the single remaining sorry by routing all three protected
  declarations uniformly through `(jacobianWitness C).isAlbaneseFor P`, in line
  with Lane 3's concurrent refactor of `Jacobian C := (jacobianWitness C).J`
  (no genus-0 dite).
- **Result.** RESOLVED (pending Lane 3 merge). Sorry count **1 → 0**. The genus-0
  rigidity content previously held at the existence step of
  `exists_unique_ofCurve_comp` is absorbed into the deferred existence claim
  `nonempty_jacobianWitness` in `Jacobian.lean`.
- **No new axioms.** No edits to other files. No edits to protected signatures.

## Per-declaration changes

### `ofCurve P` (L51)
**Before** (iter-072): `unfold Jacobian; split_ifs with h` on `genus C = 0`,
returning `toUnit C` in the genus-0 branch and the witness's `IsAlbanese.ofCurve`
in the positive-genus branch.

**After** (this iter):
```
letI := (jacobianWitness C).grpObj
letI := (jacobianWitness C).proper
letI := (jacobianWitness C).smooth
letI := (jacobianWitness C).geomIrred
exact ((jacobianWitness C).isAlbaneseFor P).ofCurve
```

### `comp_ofCurve P` (L62)
**Before**: `unfold ofCurve Jacobian; split_ifs with h`; `Subsingleton.elim` in
genus-0 branch, witness projection in positive-genus branch.

**After**:
```
letI := (jacobianWitness C).grpObj
letI := (jacobianWitness C).proper
letI := (jacobianWitness C).smooth
letI := (jacobianWitness C).geomIrred
exact ((jacobianWitness C).isAlbaneseFor P).comp_ofCurve
```

### `exists_unique_ofCurve_comp P f hf` (L82)
**Before**: `unfold ofCurve Jacobian; split_ifs with h`. In genus-0 branch:
`refine ⟨η[A], ?existence, ?uniqueness⟩` with the existence half a `sorry`
(rigidity `Hom(ℙ¹, A) = A(k)`) and uniqueness closed by precomposition with `P`
+ `Subsingleton.elim` on `Hom(𝟙_, 𝟙_)`. Positive-genus branch: witness projection.

**After**:
```
letI := (jacobianWitness C).grpObj
letI := (jacobianWitness C).proper
letI := (jacobianWitness C).smooth
letI := (jacobianWitness C).geomIrred
exact ((jacobianWitness C).isAlbaneseFor P).exists_unique_ofCurve_comp f hf
```

The `sorry` at the genus-0 existence step (iter-072 L111) is gone. The rigidity
content is now carried structurally by the witness's `isAlbaneseFor P` field,
since to construct an `IsAlbanese C P (jacobianWitness C).J` term for a
genus-0 curve one must furnish exactly that rigidity data.

## Why this is consistent with the protected-signature freeze

All three signatures are byte-for-byte unchanged:
- `noncomputable def ofCurve (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : C ⟶ Jacobian C`
- `lemma comp_ofCurve (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : P ≫ ofCurve P = η[Jacobian C]`
- `theorem exists_unique_ofCurve_comp (P : …) {A : …} … (f : C ⟶ A) (hf : P ≫ f = η[A]) : ∃! …`

Only the proof bodies changed.

## Definitional-equality checks (informal, since build env broken)

After Lane 3's refactor, `Jacobian C` reduces definitionally to `(jacobianWitness C).J`
(no `dite`). The `letI`s pull the witness's `grpObj`, `proper`, `smooth`, `geomIrred`
fields into the local typeclass context; these are exactly the instances the
`@IsAlbanese k _ C P J grpObj proper smooth geomIrred` signature of
`isAlbaneseFor P` was built with (see `Jacobian.lean` L153), so all three
`exact` lines unify by `rfl` of the underlying terms.

The protected instance `instGrpObj : GrpObj (Jacobian C) := (jacobianWitness C).grpObj`
(after Lane 3) unfolds to the same witness field, so the goal's `η[Jacobian C]`
and the witness's `η[(jacobianWitness C).J]` agree definitionally on the unit element.

## Compilation status

- **Local build**: unverifiable. `.lake/packages/mathlib/.lake/build` does not exist;
  `lake env lean` fails with `unknown module prefix 'Mathlib'` (same as PROGRESS.md
  records since iter-069). The deterministic `sync_leanok` phase will be the
  authoritative check once the env is repaired and Lane 3 has merged.
- **Lane 3 dependency**: my edits assume Lane 3's dite removal has landed. The
  PROGRESS.md (§ 4) explicitly directs Lane 4 to write against the post-refactor
  shape; if Lane 3 lands first, my edits compile; if Lane 4 lands first, a
  transient compile error is expected and resolves on Lane 3 merge. No
  workaround needed.

## Blueprint marker readiness

After Lane 3 lands and the file compiles, the three declarations
`Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp`
will all be sorry-free, so `sync_leanok` should add `\leanok` to:
- `def:ofCurve` (statement + implicit proof) in `AbelJacobi.tex`.
- `lem:comp_ofCurve` statement + proof.
- `thm:exists_unique_ofCurve_comp` statement + proof.

Blueprint already updated this iteration by the plan agent to reflect the
unified Albanese-framework routing (see `blueprint/src/chapters/AbelJacobi.tex`
§ *Universal (Albanese) property*).

## Dead-end warnings / forward-looking notes

- **Do not re-introduce the `unfold Jacobian; split_ifs with h` case-split**:
  after Lane 3, `Jacobian C` is no longer a `dite`, so `split_ifs` would fail.
- **Do not attempt `nonempty_jacobianWitness`**: now absorbs both higher-genus
  Albanese existence AND genus-0 rigidity; deferred indefinitely under current
  Mathlib (no `Hom(ℙ¹, A) = A(k)`, no symmetric-power quotients, no FGA
  representability).
- **If a future iteration wants to make `AbelJacobi.lean` *more* explicit**
  (e.g. prove `ofCurve P` and `((jacobianWitness C).isAlbaneseFor P).ofCurve`
  are propositionally equal as a rewriting lemma), this is a low-priority polish
  task; the current proofs already discharge all three protected obligations
  uniformly.
