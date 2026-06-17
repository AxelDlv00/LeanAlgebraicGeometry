# Strategy-Auditor Directive

## Slug
quot-spike210

## Mission
Feasibility-gate the **A.2.c Quot/Cartier engine** — the single largest phase of
the project's primary goal (Pic_{C/k} representability), estimated ~2000–4000 LOC
and resting on the Quot scheme, which is ABSENT from Mathlib. The project must not
build ~50 iterations of substrate around this crux without first confirming it is
Lean-expressible and decomposing it into concrete sub-phases. This is a read-only
spike; produce a feasibility verdict and a sub-phase decomposition.

## Context (what the strategy currently assumes)
- The primary near-term goal is a complete proof of representability of the
  relative Picard functor `Pic_{C/k}` for `C` a smooth proper geometrically
  integral curve over a field `k` (USER primary directive; no `C(k)≠∅`, no
  `CharZero`). `J := Pic⁰_{C/k}`.
- The strategy claims representability is **RR-free** (Riemann–Roch-free), via
  Nitsure §5 + Kleiman §4, and that it is achieved by a Quot/Cartier construction
  discharging six Prop-valued typeclass `⟨sorry⟩` constructors.
- The Quot engine is currently only partially scaffolded (`QuotScheme.lean`,
  `FlatteningStratification.lean`) and is gated behind this spike.

## Tasks (read the SOURCES directly, then judge)
1. **Read the primary sources** (do not rely on summaries):
   - `references/nitsure-hilbert-quot.pdf` — §3–§5 (Quot functor definition,
     boundedness, representability of Quot, flattening stratification).
   - `references/kleiman-picard.pdf` — §4 (existence of the Picard scheme from
     Quot), and how §4 uses the Quot scheme.
2. **Confirm the construction shape on the project's base.** Is the Quot functor
   as Nitsure defines it (Quot of a coherent sheaf on a projective scheme over a
   Noetherian base) directly applicable to the relative curve setting `C ×_k T`,
   or does Kleiman's Pic construction need a variant (e.g. flattening + relative
   effective Cartier divisors)? Name the exact construction Kleiman §4 invokes.
3. **Survey present Mathlib** for any Quot/Hilbert-scheme, flattening-stratification,
   relative-effective-Cartier-divisor, Hilbert-polynomial, or
   representable-functor-of-schemes API. State what exists and what is absent.
4. **Decompose the engine into concrete sub-phases** with, for each: a one-line
   mathematical statement, a rough LOC estimate, and whether it rests on an
   absent-from-Mathlib prerequisite (and if so, name it). Expected rough spine:
   Quot functor → boundedness → representability of Quot → flattening
   stratification → Cartier/Pic representability.
5. **Verdict:** is the engine FEASIBLE to build project-side from present Mathlib
   (one lemma at a time, axiom-clean), or does it bottom out in a prerequisite so
   large it needs an upstream Mathlib contribution first? Flag any hidden
   prerequisite (projective embedding of the curve, Hilbert polynomial machinery,
   relative Proj, etc.) that the strategy currently assumes is available but is not.

## Out of scope
- Do NOT audit the TS (TensorObjSubstrate) lane or the Albanese routes.
- Do NOT propose Lean code; this is a feasibility + decomposition spike.
- Do NOT decide the `degComp` vs `Pic^z` identity-component question (separate).

## Deliverable
A report at `task_results/strategy-auditor-quot-spike210.md`: the feasibility
verdict, the sub-phase decomposition table, the Mathlib-gap list, and any
strategy-modifying finding (e.g. "representability is NOT RR-free as Kleiman §4
actually uses X" — that would be a critical correction).
