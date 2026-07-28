Fresh-context audit of ONE session's work in the Lean 4 project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (project root; Lean under AlgebraicJacobian/). I am the `ajcr-cert-r2` lane, run 0070 session 0010. Be adversarial: I want defects found, not confirmation.

THE WORK: nine ledger commits, ancestors of HEAD 2cdf3e343 —
  ed13f29a1  Picard/DivisorFamilyAffFace.lean       (new, 184L)
  2a1e05623  Picard/DivisorFamilyAffVehicle.lean    (new)
  a5c5ca3e9  + its `section Compare`                (now 292L total)
  2456cc7b6  docstring corrections in AffVehicle
  0743f5a5c  Picard/DivisorFamilyAffGlueZarKit.lean (new, 646L)
  fae9b7448  Picard/DivisorFamilyAffGlueZar.lean    (new, 302L)
  43beb3aeb / 132ac965a / 2cdf3e343  informal/spec-dd-r.md ADDENDUM 8 (§8.1–8.6)

THE CLAIMS I AM MAKING, each of which I want you to try to break:

1. "Outside the thirteen pre-existing `DivisorFamilyAff*.lean` files, the name `DivFamZarAff` appeared nowhere in the tree before this session, so the widened carrier had no consumer." (Check against the ledger, e.g. `git show ed13f29a1^:...`, not against the current worktree.)

2. "`DivFamZarAff` had `mapAlg` but no `mapAlgHom`, and the vehicle/functor layer (`divFamZar` in Picard/DivisorFamilyZarVehicle.lean:187, `divFunctor` in Picard/DivisorFamilyZarFunctor.lean, `DivRepGlobalData` in Picard/DivRepKit.lean) is stated ENTIRELY at `mapAlgHom` / `Over.resAlgHom`, hence nothing could consume the widened value." — is that actually true of all three, or did I overstate it?

3. "`divFamZarAffAffineEquiv` carries the certificate lane's endpoint into a vehicle section over an AFFINE test." I claimed this but did NOT land a Lean composition of `divFamZarAff_of_forall_prime_certified_adaptation` (Picard/DivisorFamilyAffAssemble.lean:139) with the equivalence — my probe attempt was abandoned when builds contended. So: does that composition actually typecheck? If you can cheaply write it as a scratch file and elaborate it, do; if it does NOT compose, that is the most valuable thing you can tell me.

4. "`DivFamZarAff.exists_glue_of_away_compat` (Picard/DivisorFamilyAffGlueZar.lean:91) makes the widened value a Zariski SHEAF value." Check the statement is the intended one and NOT vacuous or circular: in particular (a) whether its hypotheses can be jointly satisfied, (b) whether it secretly assumes what it proves, (c) whether `AwayCompatPullDivEq` in the Kit binds its regularity witnesses in a way that makes the compatibility trivially satisfiable (the Kit's docstring claims the `∀` spelling would be "a vacuous obligation" and that existential binding is correct — verify or refute that claim, it is not mine and I did not check it).

5. "No hypothesis on `|P¹(k)|` occurs anywhere in the widened chain." Verify by inspection of the actual signatures in the four new files.

6. The docstrings advertise declarations. Check EVERY name in every `## Main declarations` list in the four new files actually exists with that exact fully-qualified name. This tree has been bitten twice by phantom lists, once by me this session.

MANDATORY METHOD:
- Use the Lean LSP MCP tools for elaboration checks. For a kernel check, `lake env lean <file>`, and you MUST hold the mkdir mutex (a DIRECTORY lock, NEVER flock it):
    LOCK=/tmp/claude-1001/ajcr-locks/lake.lock
    while ! mkdir "$LOCK" 2>/dev/null; do
      if [ -f "$LOCK" ]; then rm -f "$LOCK"; continue; fi
      h=$(cat "$LOCK/pid" 2>/dev/null); if [ -n "$h" ] && ! kill -0 "$h" 2>/dev/null; then rm -rf "$LOCK"; continue; fi
      sleep 10
    done
    echo $$ > "$LOCK/pid"; trap 'rm -rf "$LOCK"' EXIT
  Release with `rm -rf "$LOCK"`. Builds are heavily contended (8 lanes) — prefer LSP and targeted `lake env lean` over full builds, and put any scratch file in /tmp, NOT in the project.
- Do NOT commit, do NOT edit any file under AlgebraicJacobian/ or informal/. Report; I apply.
- For axiom probes remember trap (c): a clean `#print axioms` says nothing if hypotheses cannot be jointly satisfied, and always include a control that DOES report sorryAx.

REPORT: each of the six claims marked CONFIRMED / OVERSTATED / REFUTED with the specific evidence you ran, then any defect you found that I did not ask about, ranked by severity. Do not claim you verified something you could not run — say "not run" and why.
