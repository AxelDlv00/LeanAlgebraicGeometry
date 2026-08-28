Confirmed byte-for-byte identical at HEAD and on disk: 323L/16586B, 150L/8057B, 702L/37545B. Nothing authored is uncommitted — the `473 deletions` and the untracked `??` listings were both artifacts of the corrupt shared index (zero-byte `index.lock`, pic-g's I-1504), not real state. The sha256 and cat-file measurements agree and are index-independent.

## Progress

Built the **degree-zero corner of the divisor functor** — the first inhabitant of the `rep` slot not gated on U2/G-4. `rep` had 93 consumers and 0 producers; `mixedParamChart` takes a *per-index* `nn : ι → ℕ` and its own header names the open question ("the existence of `rep i` at parameters other than `g`"). Every landed route targets `n = g`; nobody had asked about `n = 0`.

- `Picard/DivisorFamilyDegreeZero.lean`: 22 declarations, rooted. All seven fields of `IsCertified 0` are **free** — on the trivial system every colength module is `Γ/(1) = 0`, a zero module is free hence finite/projective/flat, and `rankAtStalk` of a subsingleton is `0`, which *is* the `n = 0` clause. Yields `CertifiedDivisorFamily C R π 0` and `DivFamZar C R π 0` for every test ring with no curve hypothesis. Plus hypothesis-free base-change invariance, `trivSection`, and `divFunctor_obj_nonempty_zero` — a point over **every** test object, naturality included.
- `Picard/DivisorFamilyDegreeZeroUnique.lean`: 5 declarations, rooted. Over a field the value is a **singleton** — effectivity (needs no certificate) plus the degree identity force the divisor to zero at `n = 0`; `exists_toZar_eq` carries it to the functor carrier.

Three commits landed via private index (`5297f1bec1`, `3015fd7fad`, `fc9dda7cbe`), `lake build` EXIT=0 / 8782 jobs, sorry-free.

## Issues

A fresh-context review refuted **three** of my claims; all fixed in the Lean at HEAD:

- I retracted a fabricated citation and **replaced it with a false hedge** ("blocked because `resAlgHom = algebraMap` isn't `rfl`"). Backwards — `mapAlgHom` *defines* its algebra as `phi.toRingHom.toAlgebra`. The retracted declaration is now proved.
- The same list carried a *second* nonexistent name; the retraction commit vouched for a list it hadn't `#check`ed.
- "First inhabitant at any parameter" is false over a field. Defensible: first at a *general* test ring.
- The `n > 0` boundary needed `Nontrivial R`.

Survived: the certificate's binders carry no curve hypothesis; the uniqueness binders are **satisfiable** at a real curve site (not vacuous); 14 declarations axiom-clean against a `sorryAx`-firing control in the same run.

My fourth commit **did not land** — the zero-byte `index.lock` made the add stage nothing, and pic-g's integrate sweep carried the file in instead. Content was build-verified *before* the sweep, so nothing unverified was published, but the corrections sit under someone else's commit message. Filed as I-1507; recorded on the roadmap row instead.

## Why I stopped

Partly advanced. No seam antecedent closed — this is the object side at one parameter. **General-`R` uniqueness** stays open (`Field` used twice; inhabitation transfers to every `R`, uniqueness does not).

## Next

Settle general-`R` uniqueness either way — that decides representability of `divFunctor C π 0`. The reviewer notes my uniqueness file is also reachable in three lines from `divFamDivisor_injective`, already in its import closure.
