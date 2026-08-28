Boundary clean. Five commits in HEAD (`ajc-rr`'s file landed in the interim; `ajc-fbc`'s remains their live work, correctly untouched by me). All eight of my paths byte-identical to HEAD, index defused.

## Summary

Three obligations the Albanese leg had recorded as genuine walls — each for multiple rounds, each in a docstring written by an earlier session of *this same lane* — turned out to be artefacts of bookkeeping. All three fell in a few lines each. A fresh-context review then found one of my "demolished walls" was demolished at the wrong object, and a janitor found my own retraction had left the retracted sentence intact twenty lines above it. Both fixed; those findings are the more useful half of this report.

## Progress

- `Albanese/GrpObjFoldSum.lean`: +82 lines, 0 sorries. `permAut_comp` (`permAut σ ≫ permAut τ = permAut (σ * τ)` — a *homomorphism* for composition), `permAut_one`, `permAutIso`, `permAutHom : Equiv.Perm (Fin n) →* Aut (C^n)`. Two files recorded this as "not free" because `permAut` was never shown invertible; `permAut σ⁻¹` is a two-sided inverse. The inverse visibly carried by `SymPowColimit.permEnd` is forced by `End`'s **reversed** multiplication, and reading it as a fact about `permAut` is what hid the isomorphism.
- `Albanese/StableAffineCoverGroup.lean`: the `S_n` instantiations its own scope note said had "no producer" for three rounds. The blocker was a universe binder copied from the Galois source (`G : Type u` tied to `Scheme.{u}`), excluding `Equiv.Perm (Fin n) : Type 0`; the underlying prime-avoidance lemma was already index-polymorphic.
- `Albanese/TensorPowerCoproduct.lean` (new, 285 lines, 0 sorries): the n-ary coproduct universal property of the tensor power. Both halves were already in mathlib, unbundled and never named a colimit — uniqueness **is** `PiTensorProduct.algHom_ext`, existence one `liftAlgHom`. Only the binary *pushout* is packaged as a colimit, which is what the earlier search had compared against.
- `AlgebraicJacobian.lean`: rooted the new module (an unrooted module is invisible to the axiom probe).
- `AlbaneseUP.lean`: **6 sorries, unchanged** — measured. Stated against a `sorry`-bodied `SymmetricPower`, so discharging them would establish nothing.
- Roadmap `.symmetric` and `.universal`: rewritten, read back from disk. `.universal` named only the far residue (the gluing); there are two, and the nearer is the `Cofan` crossing.

## Issues

**Right group, wrong object.** My first `S_n` instantiation forms `C^n` in `Scheme`, but the leg forms it in `Over (Spec k̄)` — and `Over.forget` does not preserve binary products (the `Discrete (Fin 2)` instance does not synthesize). My docstring said the action's availability "is what makes item 1 consumable". False. Repaired via `permAutHomOverLeft` and `exists_stable_affineOpen_perm_over`. I fixed a universe binder one layer down and reported it as fixing the layer above.

**A variance I got backwards, caught by the kernel.** I first stated the equivariance with `f ∘ e`; the residual goal was `f (e⁻¹ i) a = f (e i) a`, true only at an involution. Correct is `f ∘ e⁻¹`. `permAut` is a homomorphism, `permAlgHom` an anti-homomorphism — a variance cannot be carried across that bridge by analogy.

**One count in three places, disagreeing.** Roadmap said 3-of-4, thread 2-of-4, file header both at once. Honest figure: **2 supplied, 1 partial, 1 open** — the `Cofan`/`IsColimit` packaging in `(Under k)ᵒᵖ` is unwritten, so `symPowData_affineAlgebra` consumes none of it. Now in one place, with a correction posted to my own thread comment.

**Retract where the claim is — fourth occurrence on this lane.** My retraction left the retracted sentence in a `/-! -/` section header; a docstring-focused pass walked past it. Also cleared two stale contradictions in `SymPowInvariantsUnder.lean` and its hgraph node.

Checks: root build **8821 jobs, exit 0**, zero warnings from my files. Root-seeded probe: 14 clean readings, all three controls still firing `sorryAx` — calibrated, not merely quiet.

## Why I stopped

**Partly advanced, not complete.** `albanese_universal_property` still reports `sorryAx`, correctly. Two of four glue-data inputs for `Sym^g C` are supplied and a third is proved at the algebra level.

The honest problem is no longer mathematics but integration: **nothing outside its own files consumes this layer, for the fourth consecutive round.** I recorded that rather than adding a fifth. The remaining wall is genuinely geometric — chart-quotient overlap cocycles and `OrbitsInAffineOpen` for the curve, where quasi-projectivity enters and mathlib has no such vocabulary at this pin. Task left non-terminal, so it returns to the queue.

## Next

In order, and the first is small: (i) write the `Cofan`/`IsColimit` packaging in `(Under k)ᵒᵖ` so `symPowData_affineAlgebra` literally consumes `TensorPowerCoproduct` — that converts item 3 from partial to done and is bookkeeping, not mathematics; (ii) only then the glue data. Do not open a new front before (i): a layer with no consumer is what the last four rounds produced.
