## File to check

- Lean file: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint chapter: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## iter-184 change

Lane M↓ replaced the bare `hreg_dim` sorry inside `Scheme.localRing_dvr_of_codim_one` with a structured `refine ⟨?_, ?_⟩` proof:
- Krull-dim half closed Tier-1 axiom-clean via `Scheme.ringKrullDim_stalk_eq_coheight` (iter-183 `Albanese/CoheightBridge.lean` bridge) + `exact_mod_cast _hz`.
- `IsRegularLocalRing` half retained as a typed sorry with explicit Stacks 00TT gap docstring (iter-185+ work).

New import: `AlgebraicJacobian.Albanese.CoheightBridge`. File sorry count unchanged (3 → 3) because the conjunction split adds one sorry while closing one.

## What I expect

- Does the chapter prose for the `IsRegularLocalRing (stalk z)` half of `localRing_dvr_of_codim_one` cite Stacks 00TT (or its equivalent) clearly enough that an iter-185+ writer can expand it without needing further analyst help?
- Does the chapter mention the smoothness + algebraic-closed hypothesis path (Smooth X.hom + IsAlgClosed kbar ⟹ regular at stalk) as the intended route?
- Is the Krull-dim half blueprint-documented (or should the chapter be updated to reflect that this half is now Lean-shipped)?

## Out of scope

- Other files / chapters.

## Report length

Under ~150 lines.
