# strategy-critic ts230 — directive

Fresh-mathematician read of the strategy below. You have NO iter history — challenge the strategy
on its merits. One prior CHALLENGE (iter-229) remains LIVE and is re-asked at the end.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations giving an
Albanese/Jacobian object `J := Pic⁰_{C/k}` for a smooth proper geometrically irreducible curve
`C/k` (`[Field k]` only — no `C(k)≠∅`, no `CharZero`). End-state: zero inline `sorry` in the
dependency cone of each protected decl, 0 project axioms, kernel-only axioms.

## STRATEGY.md (verbatim)
<<<
[See the file at .archon/STRATEGY.md — reproduced below>>>

(The dispatcher is pasting STRATEGY.md verbatim into your read context via the file path
.archon/STRATEGY.md. Read it there.)
>>>

## References index (references/summary.md — topic pointers)
- challenge.lean.ref — authoritative formal signatures.
- kleiman-picard — FGA "The Picard scheme": §4 existence, §5 Pic⁰/Jacobian, §6 Pic^τ.
- nitsure-hilbert-quot — Quot/Hilbert construction engine.
- abelian-varieties (Milne) — rigidity, Thm 3.2 (rational→AV constant), Albanese UP Prop 6.1/6.4,
  autoduality 6.6.
- stacks-modules (Tag 01CR) — invertible modules; dual of an invertible module is invertible.
- stacks-{varieties,fields,algebra,coherent,constructions} — geometric reducedness/smoothness,
  standard smooth Ω, relative spectrum, flat base change of R^i f_*.

## Blueprint chapter titles (one-line topics)
- Picard_TensorObjSubstrate — the ⊗-substrate: Pic group law on locally-trivial iso-classes,
  tensor/dual restriction-compatibility, the shared slice-site sheaf equivalence + its two consumers.
- Picard_{RelPicFunctor, FGAPicRepresentability, QuotScheme, FlatteningStratification, RelativeSpec,
  LineBundlePullback, IdentityComponent, Pic0AbelianVariety} — the representability arc.
- Albanese_{AlbaneseUP, CodimOneExtension, Thm32RationalMapExtension, AuslanderBuchsbaum} — UP arc.
- RiemannRoch_* — PAUSED (USER). AbelianVarietyRigidity, Genus0BaseObjects/* — rigidity arm.

## What I need
1. Is the overall strategy sound as written? Any hallucinated route, missing prerequisite, or
   unnecessary case split?
2. **Re-verify the LIVE iter-229 WATCH** (now the binding open question): the shared root
   `overSliceSheafEquiv` is a value-category-FIXED `Sheaf J A ≌ Sheaf K A`. The strategy claims each
   of the two consumers (C-bridge `dual_isLocallyTrivial` at value cat ModuleCat; A-engine
   `homOfLocalCompat` at value cat Type) reduces to this one root composed with an already-built
   per-bridge module-transport shadow. Is that reduction sound, or does the per-bridge
   `restrictScalars`/CommRingCat module transport plausibly hide a 4th cost growth that the
   "one shared root unblocks both" framing understates? The iter-230 prover is dispatched to test
   exactly this (wire a consumer onto the root). Is testing it via the C-bridge first the right
   probe, or should a different consumer be the first datapoint?
3. The standing RR-fork escalation: the RR-free engine path is ~3400–5500 LOC; lifting the USER
   ROUTE C PAUSE would enable a ~5× cheaper divisor Pic⁰ route. Is keeping this as a LIVE
   USER-decision FYI (while the loop builds the sole ungated substrate lane) the right posture, or
   does the strategy over- or under-state the asymmetry?
