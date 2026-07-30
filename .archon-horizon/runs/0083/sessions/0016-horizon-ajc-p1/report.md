The checkpoint was right and my earlier "nothing uncommitted" was wrong: it verified my Lean and board paths but never the inbox writes, and `I-1460` — the index-hazard warning itself — existed only on disk. Now committed (`bb7e7a97`-area, 10 files); all eleven paths verify HEAD == disk.

## Progress

- **`Picard/GaloisDescent/PicEtGaloisBridge.lean`** (new, rooted, 18 declarations, zero code sorries, all axiom-clean `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` as a control that correctly fires `sorryAx`): closed the coherence residue that `AJC.picrep.etale-rep.invariance` carried.
  - `invariant_of_projections_agree` — projection agreement ⟹ γ-invariance for every γ, **unconditionally**: arbitrary field, only `[Algebra k k']`.
  - `projections_agree_of_invariant`, `exists_unique_descend_picEt_of_invariant` — the converse and ajc-p2's `∃!` with γ-invariance as hypothesis, carrying **one explicit undischarged antecedent** `hcov`.
  - `selfTensorSpecCoproduct` — `Spec (k' ⊗_k k')` **is** the Gal-indexed coproduct; the only declaration carrying `IsGalois`, load-bearing there.
- **`Picard/PicEtDescentExistence.lean`**: §4 and its summary list corrected at both sites — both priced a transport through `pullbackSpecIso`/`sigmaSpec`, which is not on the route.

## Issues

**Which item and why.** ajc-p2's file had reduced the field-descent chain to one named open link whose two sides were already in-tree with nothing connecting them. Closing it changed what a consumer can *do* rather than adding another antecedent nobody holds the goal for.

**State: advanced, not closed. The seam `sorry` is untouched; no antecedent is witnessed for any curve.** The free direction is unconditional; the direction the route needs is an implication whose antecedent `hcov` I attempted and failed to discharge.

**The finding.** The residue was mispriced in *kind* — the coherence is `pullback.lift_fst`, and the real obligation is a **covering** statement. `IsGalois` enters as an antecedent, not a binder.

**Three audit findings against my own file, reproduced and fixed** (`b85ecf497a`): my `hcov` witness sits where the **consequent is also free** (satisfiability ≠ content — landed as theorems); `twistLeft`/`specGal` **already existed** one directory up, my absence census having been scoped to `Picard/GaloisDescent/`; and I **over-priced** `hcov`, whose topology half is one line.

## Why I stopped

Objective partly advanced. `lake build AlgebraicJacobian` EXIT=0, 8882 jobs, no warnings from my files. Ten commits, all ancestors of HEAD. **`I-1460` is live**: the shared index would revert 391 lines of my and ajc-p2's Lean as staged `M` against stale blobs, invisible to a `^D` grep.

## Next

`hcov`'s middle step — base change of `selfTensorSpecCoproduct` along `T_{k'} ⟶ Spec k'`, then the γ-component match. The right first target is strictly weaker: projection **inequality** at any extension with a nontrivial automorphism, which would give this row the non-degenerate model it still lacks.
