You are a read-only survey worker for prover lane `ajc-p3`. Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge (Lean 4 + mathlib). Do NOT edit any file. Report facts with file:line citations.

CONTEXT. In `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` there are TWO representability gates:
- `class HasPicScheme` (line ~263): representability of the UNSHEAFIFIED `PicScheme.picSharp C`. It has NO instance; its only producer is the theorem `picSchemeOfHasRationalPoint` which needs `[HasRationalPoint C]` AND a comparison class `PicEtComparisonIso C`.
- `class HasPicSchemeEt` (line ~355): representability of the étale-sheafified `PicScheme.picEt C`. It HAS an unconditional instance `instHasPicSchemeEt` (line ~366), derived from the single project `sorry` `fgaPicardRepresentability` (line 339).

Because `HasPicScheme` has no instance, every declaration taking `[HasPicScheme C]` is currently a statement about no curve at all.

YOUR TASK — a precise inventory to decide whether a rewire is worth a lane's session:
1. Enumerate EVERY declaration in the project that takes `[HasPicScheme C]` (or `[PicScheme.HasPicScheme ...]`, whatever the qualified form is) as a hypothesis/instance binder. Give file:line and name for each. Count them. Group by file.
2. For each, record WHAT it uses the gate for. Concretely: does it only use `PicScheme C` (the extracted carrier) and `PicScheme.representable` / its `homEquiv`, or does it use `picSharp`-specific structure that has no `picEt` analogue? Read the bodies. This determines whether swapping `[HasPicScheme C]` → `[HasPicSchemeEt C]` and `PicScheme` → `PicSchemeEt`, `representable` → `representableEt` is mechanical.
3. List the étale-side API that already exists in FGAPicRepresentability.lean (search for names containing `Et`): `PicSchemeEt`, `representableEt`, `instPicSchemeEtLocallyOfFiniteType`, `instPicSchemeEtIsSeparated`, `picEtCommGrp`, and anything else — for each, say whether it is sorry-free and whether it is the exact analogue of the `picSharp` version. Is there an étale analogue of the group-scheme structure (`CommGrpObj (PicScheme C)`)? Of `Pic0Scheme`?
4. Which of the `[HasPicScheme C]` consumers are on the path to the HEADLINE (`picardJacobianWitness` / `Jacobian` in `AlgebraicJacobian/Jacobian.lean`, and `AlgebraicJacobian/Challenge.lean`)? Trace the chain from Challenge.lean/Jacobian.lean downward and say which gate the headline actually consumes: `HasPicScheme` or `HasPicSchemeEt`. Quote the relevant lines.
5. Report `PicEtComparisonIso`: its definition, whether it has an instance, and what it costs.
6. Also: are there declarations taking `[HasPicSchemeEt C]`? How many, and do they cover what the `HasPicScheme` ones cover?

Prefer `grep -rn` for known strings like "HasPicScheme" (that is what grep is good for) and read files with the Read tool. Be exhaustive on item 1 — the count and the file grouping matter. Be terse elsewhere.
